Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F7067A52D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 22:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbjAXVod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 16:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjAXVod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 16:44:33 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120B847082;
        Tue, 24 Jan 2023 13:44:32 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e16so18270538ljn.3;
        Tue, 24 Jan 2023 13:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R4IEpD9aZshjrnq+Srup39D3KYAjhRrq9qRZNhDQbZw=;
        b=OhtCGeL+X0n5LCE8IvchaPqRu+KxeSiZ0ohzBqS2Mp7J2VlzQATe8yJsxMkHACU2uI
         yn25a1V6Y3eztsmNsdUwCgvfNvUUx+J/9YG/zMVU2/Qs4Mj36xFiNCxdqj95huqvp4Yb
         iLOU8F3r/tGL+FK11zu6WxkBYhTpL/mXBoI/oTArJY6OmLWPLb8/xSCxQjN/jgR2crZ0
         MFoSxDgmc3LW7alYPATjQZYiumYTcCLcc09dSsWt6d1SdsxxjISEWq0io9k8vbDe7CLw
         klAb/i+Xb3BP2FiLHaqU2hHddMAakU9WFLoORmrMIoQ0C7jHgOjYYbwdzvVVqiRrZsuH
         zOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R4IEpD9aZshjrnq+Srup39D3KYAjhRrq9qRZNhDQbZw=;
        b=WcHEMPxoHNDBpn7v5njbRUS0nIM74GjlZjL5m3DLge7X9gcNF7qkkEihlGRftL/vUh
         urzd28rg8+bKyY9nPA5XD3tMNIuqudEA4UYLIJDVHQTNaAMkUegddFP1QPQms+ikjXsh
         8iam+YJUsRiyJ8GupdSjhne/bvaK5Y/yMMXSe40vklLiCsz2vRBO+o6LNRssTR+kP3U2
         GxYhI7h/ATwIMmCz9SRNr813DcPLfrRyJhlSniECIafT3V4w5qfKjvGJHj0OscoEVx+C
         lX/QYmEK7IhHxAFlAZHIkUk6Qz6pikM+a3oQMtJcFrnE4CQbhskiflXugN1N7B83iezF
         0R+Q==
X-Gm-Message-State: AFqh2ko4u5dhUToYYbRj3vuCSxrPeO3UasmkcCF65+UepTVoCu3TZMN0
        A2tPoOS5nxwdoJEcDa0kdNihRJDwQSoeXv49KN4=
X-Google-Smtp-Source: AMrXdXu0QWfIjYRWGz+8p7L9B9+lFy3maxvk1fReg4QhtlC0V7o9DjmS9axIQp7sTUwe7JOTSKodmQnXCmKzccJ4KHk=
X-Received: by 2002:a2e:9212:0:b0:28b:63dc:4c7 with SMTP id
 k18-20020a2e9212000000b0028b63dc04c7mr1609175ljg.423.1674596670073; Tue, 24
 Jan 2023 13:44:30 -0800 (PST)
MIME-Version: 1.0
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com> <167458712396.1259484.1395941797664824881.robh@kernel.org>
In-Reply-To: <167458712396.1259484.1395941797664824881.robh@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 24 Jan 2023 13:44:18 -0800
Message-ID: <CABBYNZKAwp3Wqjrcp4k3wvjZSNfJhRWA5ytH7oNWXCG7V4k2ow@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
To:     Rob Herring <robh@kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Cc:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        jirislaby@kernel.org, robh+dt@kernel.org, sherry.sun@nxp.com,
        marcel@holtmann.org, linux-serial@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, rohit.fule@nxp.com,
        devicetree@vger.kernel.org, amitkumar.karwar@nxp.com,
        linux-bluetooth@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        johan.hedberg@gmail.com
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

Hi Rob, Tedd,

On Tue, Jan 24, 2023 at 11:06 AM Rob Herring <robh@kernel.org> wrote:
>
>
> On Tue, 24 Jan 2023 23:17:13 +0530, Neeraj Sanjay Kale wrote:
> > Add binding document for generic and legacy NXP bluetooth
> > chipset.
> >
> > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > ---
> >  .../bindings/net/bluetooth/nxp-bluetooth.yaml | 67 +++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> >
>
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>
> yamllint warnings/errors:
> ./Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml:67:1: [warning] too many blank lines (2 > 1) (empty-lines)
>
> dtschema/dtc warnings/errors:
> Error: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dts:18.9-15 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [scripts/Makefile.lib:434: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dtb] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1508: dt_binding_check] Error 2

I wonder if that is something that we could incorporate to our CI,
perhaps we can detect if the subject starts with dt-binding then we
attempt to make with DT_CHECKER_FLAGS, thoughts?

> doc reference errors (make refcheckdocs):
>
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230124174714.2775680-3-neeraj.sanjaykale@nxp.com
>
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
>
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>
> pip3 install dtschema --upgrade
>
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
>


-- 
Luiz Augusto von Dentz
