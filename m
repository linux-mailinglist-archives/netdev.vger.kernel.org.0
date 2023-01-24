Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E3D67A6AE
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjAXXIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 18:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjAXXIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 18:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38B44DBF4;
        Tue, 24 Jan 2023 15:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82EA3B816A2;
        Tue, 24 Jan 2023 23:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F46C433A0;
        Tue, 24 Jan 2023 23:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674601723;
        bh=ZdLDi/+DVztZ9DhXm79AtQNOd374EXmydeSyFKj+5G8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f0+/z0CMJl2SpFlJbN7wllOJMQKobBqaSrtTN5aIgyr99P3xhOM3HmjQ/DRDN+w7V
         EPvITU6fI+o8rm8pV8Ds43XsPgUFlPp6c6VmccxO66P3Bfao6Xmbno3XM7+8ArrkTJ
         Jb0lkMcUnrUXuVWYOnhetXmS+NWAtstJsI4ss7gXFlhiHO89fQ//+TeWCbxY7clRkh
         Duwr35kDQK3GBRN+ueUo1DD8fq4NGJqDwN375BE9DTjSXhZhgpQszEK6v2UsS0NXZ/
         lG5dAlBAoOu9rI7HTIKdWSxa9y4ZEX4T037tgpU9jK6SjG2qJHQSe/u3jKxGQzNqyt
         HPpnnpj5j6VMg==
Received: by mail-ua1-f53.google.com with SMTP id i23so4171388ual.13;
        Tue, 24 Jan 2023 15:08:43 -0800 (PST)
X-Gm-Message-State: AO0yUKW4/nbyGVJIxcEb5kx2dXEesw3ziUlzpStmKqMy24Zxp98Ty6b0
        V6wEsoDdlo084OCanMBuyBenzMYb54Hf7MlQmA==
X-Google-Smtp-Source: AK7set+XHOdnzF4SR3B3+FFd0Ftxg5GKYZ4DgGcss8AsTbvEbnamxUgbBbYhk446PYIeFe15Ip5Ly7OjAHZFVOHDBvM=
X-Received: by 2002:a05:6130:83:b0:655:5dfb:9d10 with SMTP id
 x3-20020a056130008300b006555dfb9d10mr331055uaf.63.1674601721971; Tue, 24 Jan
 2023 15:08:41 -0800 (PST)
MIME-Version: 1.0
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com> <167458712396.1259484.1395941797664824881.robh@kernel.org>
 <CABBYNZKAwp3Wqjrcp4k3wvjZSNfJhRWA5ytH7oNWXCG7V4k2ow@mail.gmail.com>
In-Reply-To: <CABBYNZKAwp3Wqjrcp4k3wvjZSNfJhRWA5ytH7oNWXCG7V4k2ow@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 24 Jan 2023 17:08:30 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJged+SwGy5b1w2Cx-dV06=LKb1mX9ykN7GrpR6P4gUVw@mail.gmail.com>
Message-ID: <CAL_JsqJged+SwGy5b1w2Cx-dV06=LKb1mX9ykN7GrpR6P4gUVw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Tedd Ho-Jeong An <hj.tedd.an@gmail.com>,
        Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        jirislaby@kernel.org, sherry.sun@nxp.com, marcel@holtmann.org,
        linux-serial@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rohit.fule@nxp.com, devicetree@vger.kernel.org,
        amitkumar.karwar@nxp.com, linux-bluetooth@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        johan.hedberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 3:44 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Rob, Tedd,
>
> On Tue, Jan 24, 2023 at 11:06 AM Rob Herring <robh@kernel.org> wrote:
> >
> >
> > On Tue, 24 Jan 2023 23:17:13 +0530, Neeraj Sanjay Kale wrote:
> > > Add binding document for generic and legacy NXP bluetooth
> > > chipset.
> > >
> > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > ---
> > >  .../bindings/net/bluetooth/nxp-bluetooth.yaml | 67 +++++++++++++++++++
> > >  1 file changed, 67 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> > >
> >
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> >
> > yamllint warnings/errors:
> > ./Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml:67:1: [warning] too many blank lines (2 > 1) (empty-lines)
> >
> > dtschema/dtc warnings/errors:
> > Error: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dts:18.9-15 syntax error
> > FATAL ERROR: Unable to parse input tree
> > make[1]: *** [scripts/Makefile.lib:434: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dtb] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:1508: dt_binding_check] Error 2
>
> I wonder if that is something that we could incorporate to our CI,
> perhaps we can detect if the subject starts with dt-binding then we
> attempt to make with DT_CHECKER_FLAGS, thoughts?

What CI is that?

Better to look at the diffstat of the patch than subject. Lots of
subjects are wrong and I suspect there would be a fairly high
correlation of wrong subjects to schema errors.

Rob
