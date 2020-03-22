Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5781118E65E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 05:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgCVEMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 00:12:13 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:39535 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCVEMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 00:12:12 -0400
Received: by mail-vk1-f194.google.com with SMTP id r129so2881773vkr.6;
        Sat, 21 Mar 2020 21:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZhbSsWH3Nd28xNaH9H1iKoB8x/tihaQFiafijcYuWo=;
        b=dpEJQIKP7FWxh6J4Z1n90Vtb2qSU4QCUF6i/YKT2t7xjElB3L5Zp70CJNvV7s5wlqE
         z0HL8fqQsSztYtyU9ngFAo/b+XfJ7gUBv2NGeY9j6/UfBLSf6TGxuo5jinv5R0m8RlTC
         Ym+yvMLf59g0FfI6xVlZ6FNY4cpzxOvdd1EQUGwMF/MVjPwbwbhxNx6P5Xcr63h4kIV3
         GT2PFZFhNQ3l3rAJTqd0tvXP8+BtD4SkP3zIQaE3KN7v2mn7SZwFf3cWL5167jq49o1o
         4s3YCTvrQEk4Yu3wDXoqUstsfa49ODDj1ulNNiR3MFKu4QL1ESWZte75FCF07w5R9GSi
         jXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZhbSsWH3Nd28xNaH9H1iKoB8x/tihaQFiafijcYuWo=;
        b=rVZ2R7ybJRtuTINLzn40Ck3wrkcxbim1QRXR4GDBhazMUQbVfW1NbinoO4hS+vSfJ/
         ffWrofkPBOgMl1LsV0b1GOqt3K0eCUFHFmf42Zp4WzsAWY/GwzooPykLPjXSUDEkQwwt
         bEvGENI6IzVbXHjOab5LAI3HJdw9QjKydvHKfqmOeA8cnmV2axGtilIkY+uy4Wx4hEfW
         ysAVIcETHBpG5AAZtTvClpwmw4fwr9FBI1SwDOzn+so2RbbwAuy0XN4vYW+B1O3jIjsP
         GGwWfunO6hhdxZB4Pt2f9CUcLVyz+09Mt+74kuNHWnpadmzZZckXGAi/yrjKScwYcSg3
         KQqA==
X-Gm-Message-State: ANhLgQ3aSNPizu2Kfa2WTMOWdmiQiVg/ebXjx7Gs0pdOUD2FfDi9MGsP
        UVUAiQ4g/EX+Sck2amwxxWNyb6ba9twP57euWRE=
X-Google-Smtp-Source: ADFU+vsS91fN7bZOUZ7YiLvDMR/ru1lFo1M5djZemNARcBG+g71rMTCsKgNqksfgobUXwrvgRR3rujBIRAxxZVumqD8=
X-Received: by 2002:ac5:c1ca:: with SMTP id g10mr11197264vkk.16.1584850331664;
 Sat, 21 Mar 2020 21:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Sun, 22 Mar 2020 12:11:58 +0800
Message-ID: <CADG63jB59ZXWSUFKieXKGGEbPT9=z5OPARBjGqMgfh+K-k4-yQ@mail.gmail.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
To:     syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/hqj/hqjagain_test.git sctp_for_each_tx_datachunk
