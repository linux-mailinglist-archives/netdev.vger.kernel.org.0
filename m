Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1504D6246E0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiKJQ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKJQ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:27:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEC51D665;
        Thu, 10 Nov 2022 08:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7139B821E5;
        Thu, 10 Nov 2022 16:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3F1C433B5;
        Thu, 10 Nov 2022 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668097631;
        bh=GsCcsPElGsFJUuzJrhB310M1CS+bTsLUo9xdF6g3A/8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c8PxCfCcWAD3q9LkHg+RMrHD+GcZZ8EEIO9VkGzqw5rdK/gaM07AtHlSV5KRULwQc
         ZDLs/R/3BbqlvdkZMtVuraxDytlLmpaNgFPYKBTIkYdTypamLJwLkeL2EiLQWsNyYG
         IFiTeajEBRQy80ibVzj9Om649XLI7PRP+zHmA0JCxBlYoWc/L+ybJGbSoyUmWY8p8b
         MgJnAyJ/MoMcHLMukBgT2a+uYYhha+3e97IY/ASIbFlt0+HZOcpSty+126Fe78nDLl
         3dqscYJleJWFP+/ERvFgLTs1jouipzKj1gCEARtxsu6ZpS+1o0HyW+5tTzXS0lNO35
         pRbZq0QPyyVnw==
Received: by mail-lf1-f48.google.com with SMTP id bp15so4221377lfb.13;
        Thu, 10 Nov 2022 08:27:11 -0800 (PST)
X-Gm-Message-State: ACrzQf0oGl3AwA9P1N9I+KZdtXEz0f7PKhyDERYgLJSFfd85UxI8P/5P
        VBWJ+ESam1KFir1+RqKJrabfYVxLx2sk8sBKcw==
X-Google-Smtp-Source: AMsMyM5rYSshTayFGF4hfoebb/Hmir7Ww6/F/8OwM1Hop771tenHmLyATJhskKsf70VK5iaAr/GNOGkLnYKqrFtlwfQ=
X-Received: by 2002:a05:6512:3e10:b0:4a2:48c1:8794 with SMTP id
 i16-20020a0565123e1000b004a248c18794mr21536008lfv.17.1668097629273; Thu, 10
 Nov 2022 08:27:09 -0800 (PST)
MIME-Version: 1.0
References: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
 <6a4f7104-8b6f-7dcd-a7ac-f866956e31d6@linaro.org> <Y2rsQowbtvOdmQO9@atmark-techno.com>
 <Y2tW8EMmhTpCwitM@atmark-techno.com> <20221109220005.GA2930253-robh@kernel.org>
 <Y2yqSxldXPdmkCpW@atmark-techno.com>
In-Reply-To: <Y2yqSxldXPdmkCpW@atmark-techno.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 10 Nov 2022 10:27:00 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLjmgDsXnr_xqjfcFH1v0MB+W-X6i=iPh0tCq=ZLDhkNw@mail.gmail.com>
Message-ID: <CAL_JsqLjmgDsXnr_xqjfcFH1v0MB+W-X6i=iPh0tCq=ZLDhkNw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 1:38 AM Dominique Martinet
<dominique.martinet@atmark-techno.com> wrote:
>
> Rob Herring wrote on Wed, Nov 09, 2022 at 04:00:05PM -0600:
> > Punting the issue to userspace is not a great solution...
>
> I can definitely agree with that :)
>
> Userspace has the advantage of being easy to shove ugly things under the
> rug, whereas I still have faint hope of keeping down the divergences we
> have with upstream kernel... But that's about it.
>
> If we can work out a solution here I'll be very happy.
>
>
> Rob Herring wrote on Wed, Nov 09, 2022 at 04:00:05PM -0600:
> > > This actually hasn't taken long to bite us: while the driver does work,
> > > we get error messages early on before the firmware is loaded.
> > > (In hindsight, I probably should have waited a few days before sending
> > > this...)
> > >
> > >
> > > My current workaround is to return EPROBE_DEFER until we can find a
> > > netdev with a known name in the init namespace, but that isn't really
> > > something I'd consider upstreamable for obvious reasons (interfaces can
> > > be renamed or moved to different namespaces so this is inherently racy
> > > and it's just out of place in BT code)
> >
> > Can't you just try to access the BT h/w in some way and defer when that
> > fails?
>
> This is just a serial link; I've tried poking at it a bit before the
> firmware is loaded but mostly never got any reply, or while the driver
> sometimes got garbage back at some point (baudrate not matching with
> fresh boot default?)
> Either way, no reply isn't great -- just waiting a few ms for reply or
> not is not my idea of good design...
>
> > Or perhaps use fw_devlink to create a dependency on the wifi node. I'm
> > not sure offhand how exactly you do that with a custom property.
>
> That sounds great if we can figure how to do that!
> From what I can see this doesn't look possible to express in pure
> devicetree, but I see some code initializing a fwnode manually in a
> constructor function with fwnode_init and a fwnode_operations vector
> that has .add_links, which in turn could add a link.

If the wifi node was a standard provider (clocks, resets, etc.) to the
BT node, it does just work with DT. The issue here is either you'd
have some custom property or no property and the BT side driver just
knows there is a dependency to create. That case is what .add_links is
for IIRC.

> ... My problem at this point would be that I currently load the wireless
> driver as a module as it's vendor provided out of tree... (it's loaded
> through its pci alias, I guess it's udev checking depmod infos? not
> familiar how that part of autoloading really works...)

Well, that's a fun complication. I guess it has no DT info? You can
populate your DT with the necessary PCI nodes to represent the wifi
device. Under the PCI host node, you'll need at least a root port node
and then probably the wifi device is under that. It's got to match the
hierarchy to assign a device_node ptr to the PCI device.

Module aliases are the magic that makes the autoloading work.

> But that makes me think that rather than defining the bluetooth serdev
> in dts early, I could try to have the wireless driver create it once
> it's ready? hmm...

That is yet another option. The wireless driver could create the BT
device when ready. The issue there is serdev devices created
asynchronously isn't supported. serdev looks if the serial device has
a child node and will register with serdev and create the serdev
device. Otherwise, the serial device is bound to the tty layer.

Rob
