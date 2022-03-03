Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506714CBE3B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiCCM5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiCCM5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:57:23 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916E186218
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 04:56:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s24so6501179edr.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 04:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xg/x72ENVz5iA/OUZTq9flFI693xAYRwtey/DYACqA4=;
        b=GvT91XYYJZqzCOhueU90VTjma/myPgMVy5dFIkkTTk4k1lSYQvFhNAtq3pQw/slDwY
         ISpk08vciFEHv1nwFS+M0VBAj9e+J8rncrf5uT/kJHmzNAVNgqMCCCkxlTEXeUkKbOd/
         aWE0sL3aMqOwIjfgJMrcyhld9MqsRRYK/UU8Kl8bdEhPcDPCOAJgX34phq6ERjkmlsK7
         PGzp8BZKzB0sZ3D0mq9YAD/R8PE7A/j0CGxG+byWmg2B71+ufMzTbG2d6Csca2ptxZJ2
         WyGdl/8KpHvJHxhNYhDzYwdnr4fzAVbfyV67B0wf9wWP9cy7TaAR2w7SklwO+g//Hqs9
         v0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xg/x72ENVz5iA/OUZTq9flFI693xAYRwtey/DYACqA4=;
        b=Ky1xUE5maEymAELLVc53Sx7Kwg/jX268iApSU3B6vbqMPqWA7m+Hcu00kSx4/gMdrC
         qWtk0UpPzppTO42EbBqqT3az6635MONuAwznh0oo8t/Cf4+CagucPeLF9mTwBBm2bRq4
         Kop/teNo9x6qCu9oiMbjkaNVxixFhBrgoNoopmB8rjasKZKIyBu0//6zeV++29aRJd/A
         0WvlIkhSCe+4bnvPPZNZrP/ZpeSYKgXM8oApIUPbS8YApElyVvTBgB8hAeaGNcvazVQQ
         TjuctPYBCJSowveckkQhYhmJ2K655qyvWvsnKd4jOtoHEnamDsQbdPPR71p96Dw0XNbv
         pjnQ==
X-Gm-Message-State: AOAM5323DIjXh/+lhDCF3Alv3Le6kCNHFwGd/v7sahTS4P1kdGhYQTkl
        2SEw3oaCZGLF1bkxd93UFvwvB4ehqJZWscDNE3kV3673KAw=
X-Google-Smtp-Source: ABdhPJyGMlNErgbhGPEqrSEJTSCw+03cm8aetw0psdCHq2AUIwOOOXO2Szm2s1/bEK8ahkyeyWidOydChRFz2pOD06M=
X-Received: by 2002:a05:6402:1e8b:b0:3da:58e6:9a09 with SMTP id
 f11-20020a0564021e8b00b003da58e69a09mr33828591edf.155.1646312195828; Thu, 03
 Mar 2022 04:56:35 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
 <Yh/r5hkui6MrV4W6@lunn.ch> <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
 <YiACuNTd9lzN6Wym@lunn.ch> <CAOMZO5ChowWZgryE14DoQG5ORNnKrLQAdQwt6Qsotsacneww3Q@mail.gmail.com>
 <YiAorTOXfE20snfz@lunn.ch>
In-Reply-To: <YiAorTOXfE20snfz@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 3 Mar 2022 09:56:23 -0300
Message-ID: <CAOMZO5DFoQCA_Sz3Ec2oT1F6PkgS9E5MCimYwV99YjvM9DygnQ@mail.gmail.com>
Subject: Re: smsc95xx warning after a 'reboot' command
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Mar 2, 2022 at 11:32 PM Andrew Lunn <andrew@lunn.ch> wrote:

> I'm not a USB expert, but to me, it looks like the smsc95xx device is
> being disconnected, rather than being unloaded. So it is already gone
> by the time the PHY device is disconnected.

Yes, with 5.17-rc6 there are smsc95xx register accesses happening
after the device gets unregistered:

smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1,
smsc95xx USB 2.0 Ethernet
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS

> It would be good to have somebody who understands USB net devices to
> take a look at this, in particularly the order. I'm wondering if there
> is a hub in the middle, and the hub is being disabled, or a regulator
> for the hub etc?

Yes, let me start a new thread with some USB folks on Cc.

I will focus on fixing the 5.17-rc6 issue first.

Thanks
