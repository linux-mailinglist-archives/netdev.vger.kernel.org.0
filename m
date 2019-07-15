Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55C269BB1
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 21:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfGOTvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 15:51:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43362 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbfGOTvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 15:51:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so7908547pfg.10
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 12:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pfh2lzCdNDTHHFsEMP5qPAyoLORyFf/dwVFrraeIrT0=;
        b=IGPdrS8lyzxkO+BjKICnskxYl/6n46EvF3P/W75B+O8xpmNydpImcwFJLClnlor9dH
         P6yHwZ9ZPjmmqQ/LJFL8zPnKXm2D7ga5J26poWyagU+yznO7jYOKuzn+HiVmk7PVVm3r
         7RYwCAbRhQgdTrXzBp7DNwnpNsjLryTbfV0A8GxrJOieBE3+/lm8Zb2Ggx1wOgSK0ZOS
         sXYAZEQm1xyBOQ5YzlAAYxv9eHIUwjjnqn9gQnqcNfigOKguiuvnSHrJq7EpMkLLp4SG
         +S7syUYH4xcPtidR9mQUMwUJBFWVCF/EQKIeSlPKPMEF0GK2jLZaH1Jr9xrjSP5O1OY7
         /JwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pfh2lzCdNDTHHFsEMP5qPAyoLORyFf/dwVFrraeIrT0=;
        b=RsFtd6b56MjwWt+gEqxmpq1d5HxuWf7j5WsZmTZpN+Rbh6A4ql4WZDsZl/pHweekL3
         MB+GZpPPewH4ooMu0pWO613n/JfV/NzwHepVUrkL5aTovf8SzWUyLg3iiS19q2q9pYJA
         d+UFiKyzq42R6Olc6+mJxdz6w7Ewa5x9FVRlfUOs2B48XhW7LP1eJ8cowHqcnYwIC5Pt
         lWncDve81sESWqbzJ6hk1gtBdmGD8ABu26QFvuJHJGyXynr0zDoxefrJM4YiefZLC58J
         lh+InGUmtURRiqBgqdwwHqU82KyF1iG6BiSw3Q8AlWNhvvsS87b55sGqcdbYiB8XAjjY
         mmOQ==
X-Gm-Message-State: APjAAAXQIN7h6womU3JuNIk0IYAFZ2k8cyg8SSoOFhLK+2tKyPZXCTBs
        RlmbABTjVdT1pyO0vRSXS5c=
X-Google-Smtp-Source: APXvYqzbvk2PQ/e59+gGvWou+jDXyEf6EZJvYuQTMj8tFOTVu7aeLcC/KY5SPq0ji+B29yMr0j9Gzg==
X-Received: by 2002:a65:4509:: with SMTP id n9mr13277865pgq.133.1563220266526;
        Mon, 15 Jul 2019 12:51:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p65sm18599193pfp.58.2019.07.15.12.51.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 12:51:06 -0700 (PDT)
Date:   Mon, 15 Jul 2019 12:50:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
Message-ID: <20190715125059.70470f9e@hermes.lan>
In-Reply-To: <0AFDC65C-2A16-47B7-96F6-F6844AF75095@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
        <0AFDC65C-2A16-47B7-96F6-F6844AF75095@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 19:40:19 +0000
"Patel, Vedang" <vedang.patel@intel.com> wrote:

> Hi Stephen, 
> 
> The kernel patches corresponding to this series have been merged. I just wanted to check whether these iproute2 related patches are on your TODO list.
> 
> Let me know if you need any information from me on these patches.
> 
> Thanks,
> Vedang Patel


David Ahern handles iproute2 next

https://patchwork.ozlabs.org/patch/1111466/
