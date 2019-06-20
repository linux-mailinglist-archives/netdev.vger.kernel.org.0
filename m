Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0D34CCE0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfFTL1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:27:32 -0400
Received: from mail-yb1-f175.google.com ([209.85.219.175]:45703 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfFTL1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:27:31 -0400
Received: by mail-yb1-f175.google.com with SMTP id v104so1076352ybi.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 04:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8BmTGLkYQIwA+8ECRY+lEK1OQBSJkTXVyKMxPYAKV0=;
        b=KqfkBTNApV0OOHTjppv1gUK/rMvw2J2GsUpHI9A5urHWAkxK79ZXgiDGusVm0X0Tu7
         iDfWB7y2IP8dNFIUz9e/WzQkE5wa4E0EF0qsET1On0Gc3l6PtE7+YbbPBmxMpb8TO5yZ
         Aa/U35qOkZ6QegSuBgQ6DY1/VpsAjBz+PCdH1IXfHu4b+WhS23++0nigCrhc67j3UDst
         sma9U/ZKFq9D3OKu2Ie051DgOqJmV5IQFD6Y85sSQ336yT+qP/hKZ4xRQcB/4zfdJ+Cx
         9A7pG00nK3FK7KBd3CM/mugFTLNd48XE+4WseOfy+wFF2kTHovmCJNI0XH2hbRr6YTcD
         G5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8BmTGLkYQIwA+8ECRY+lEK1OQBSJkTXVyKMxPYAKV0=;
        b=N5Xha3AdH1N+38hKBd5F5049OehH9Miq0VZKB1emOz4dOFzQtpe6Q9XYFzrj8rhHyY
         nTW8Ep6+/rgA1d1ELOne8E540zNZTnhpztCmNB2kefV2PVpOW17RDtOBHh+F57cp3rhR
         05Efc0YpkPbWPM4XGSlTSXjCl6wMDdAMmMQ9veYCGTri32u+A6L5ulVkvd5sB5TK58gZ
         NfFa1wgIUVVaHxk/Dvml3fRxhRxoWJc3EnoX/SAg43kw6eN8PaIGk1ubPkjh7L8aSn8L
         ChRR2RyWBMLj08/D2oiZuqV9Z5l2ClgEbVit+mZjylR8RYxf4Li0r6A2wHuzCDNcMFEA
         XoCg==
X-Gm-Message-State: APjAAAV0ZR1Kk1TFNpRyDijhwm2wIiJP9fvyH1Tg3dzSE803mxa8Cb1P
        W7d5ttnpa7XKb1Syn7G1gQ8Okzp6LJnPAF9MfzTweA==
X-Google-Smtp-Source: APXvYqwaNz6AjiK1kj5L7lZP57rruUtEW19NFEKXfp96jNUUfip7gbtnnCAM8ukj0oFtpzV1mpV4mO3ANd6Ym/FuoXs=
X-Received: by 2002:a25:4557:: with SMTP id s84mr63303851yba.504.1561030050677;
 Thu, 20 Jun 2019 04:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <1561029880-1666-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1561029880-1666-1-git-send-email-lirongqing@baidu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Jun 2019 07:27:18 -0400
Message-ID: <CANn89iLotTxB2wAtUUynOO0ihDWdHnxVJD9TOcGx=Y06OWx0xw@mail.gmail.com>
Subject: Re: [PATCH][net-next] netns: restore ops before calling ops_exit_list
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 7:24 AM Li RongQing <lirongqing@baidu.com> wrote:
>
> ops has been iterated to first element when call pre_exit, and
> it needs to restore from save_ops, not save ops to save_ops
>
> Fixes: d7d99872c144 ("netns: add pre_exit method to struct pernet_operations")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Thanks for fixing this :)

Reviewed-by: Eric Dumazet <edumazet@google.com>
