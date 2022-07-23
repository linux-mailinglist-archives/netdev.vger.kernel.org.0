Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED657EA8C
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 02:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiGWAJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 20:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWAJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 20:09:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D593333E00;
        Fri, 22 Jul 2022 17:09:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id sz17so11120362ejc.9;
        Fri, 22 Jul 2022 17:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5TxzqAbxVVwhsQ72uHXIjwDdjtRQTpE0j+gDD2+GLGg=;
        b=lfrJ7rtraDyuuQcB/7QgdfJwwPbk8Blobx4z/wn5tb9EMzBIPyDD7iGthZkJ/WL5+x
         UFNvUtkTFk7GcXxwi1g1cInZQRa1UPmjTwNqE4t2CXGj1utrKR7aMucdygtRBstLnToO
         Ex0iYVo3RA09ToWGbRwKBaxgW5YcGbPIvzbdTbxesd87G3Yk4N3RwSemZFTatOr/VC/W
         9grHzIXQTjsMXWU1aHPKWG56JmYAM4e1WQ8974gMmqC3BEBYOHW3NQI7EAgHvvJbrE8/
         cUNszyS4wyDvVulcOs3zJiu/bpZWoao5MfOZFCYfI0jhOIHOrsYDOsFrWyOW4uJvLZvR
         BxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5TxzqAbxVVwhsQ72uHXIjwDdjtRQTpE0j+gDD2+GLGg=;
        b=z5t3otrkr6XKLWnnWJjvRakVdeII53w0cC3ZXN+K7l0i4AgC7hpV7Lxrqk8zC2Lwv1
         PykexdnvKwZ1Eyxocc4+UtHt0AU2qtbHKgPugInYdluFjKqFmuAC/RysOMWtOQoB58q1
         C1FXr105HMe7Bd/pY4GsMQTkkZuZ4eHicgaOo53AqCUldwyn5IsyNhkKYu/FWxbO+wBj
         YAiZWDq0OIH9eHEKzGqjfdf5y6u9rIa307vLEwyF/sfCOZByp4Wv9C5IGxqn0bLe+YA6
         Hcxi9/x2joZPq7TCC3uRpBgD/+hdJT+MwcS18nlvoweFMdQgfIh2oTuwIAF3olnr9LH/
         fbmw==
X-Gm-Message-State: AJIora9ZGD3S9pIBHeGyd2FdQESd0t6rhigOPUUtxwCp4R5NMhmT1Ag6
        PCSHZWcpsAb3KEhofw31BhlvIuSDlrRcVyhPX+I7qBOj8ps=
X-Google-Smtp-Source: AGRyM1tT5kH8YUE69JGHdd+78CkUO1kCPwrcKaaePNDIBFFMSiBFQQClZQmbN1JufwQvxx35l+BHZggXxlI7XRJ5EHM=
X-Received: by 2002:a17:907:2e0d:b0:72b:8cd4:ca52 with SMTP id
 ig13-20020a1709072e0d00b0072b8cd4ca52mr1716399ejc.541.1658534985118; Fri, 22
 Jul 2022 17:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220722205400.847019-1-luiz.dentz@gmail.com> <20220722165510.191fad93@kernel.org>
In-Reply-To: <20220722165510.191fad93@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 22 Jul 2022 17:09:33 -0700
Message-ID: <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2022-07-22
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jul 22, 2022 at 4:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 22 Jul 2022 13:54:00 -0700 Luiz Augusto von Dentz wrote:
> > The following changes since commit 6e0e846ee2ab01bc44254e6a0a6a6a0db1cba16d:
> >
> >   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 13:03:39 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-07-22
> >
> > for you to fetch changes up to 768677808478ee7ffabf9c9128f345b7ec62b5f3:
> >
> >   Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet (2022-07-22 13:24:55 -0700)
> >
> > ----------------------------------------------------------------
> > bluetooth-next pull request for net-next:
> >
> >  - Add support for IM Networks PID 0x3568
> >  - Add support for BCM4349B1
> >  - Add support for CYW55572
> >  - Add support for MT7922 VID/PID 0489/e0e2
> >  - Add support for Realtek RTL8852C
> >  - Initial support for Isochronous Channels/ISO sockets
> >  - Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING quirk
>
> I see two new sparse warnings (for a follow up):
>
> net/bluetooth/hci_event.c:3789:26: warning: cast to restricted __le16
> net/bluetooth/hci_event.c:3791:26: warning: cast to restricted __le16

Crap, let me fix them.

> Two bad Fixes tags:
>
> Commit: 68253f3cd715 ("Bluetooth: hci_sync: Fix resuming scan after suspend resume")
>         Fixes tag: Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend with
>         Has these problem(s):
>                 - Subject has leading but no trailing parentheses
> Commit: 9111786492f1 ("Bluetooth: fix an error code in hci_register_dev()")
>         Fixes tag: Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
>         Has these problem(s):
>                 - Target SHA1 does not exist
>
> And a whole bunch of patches committed by you but signed off by Marcel.
> Last time we tried to fix that it ended up making things worse.
> So I guess it is what it is :) Pulling...

Yep, that happens when I rebase on top of net-next so I would have to
redo all the Signed-off-by lines if the patches were originally
applied by Marcel, at least I don't know of any option to keep the
original committer while rebasing?

-- 
Luiz Augusto von Dentz
