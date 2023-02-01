Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06800686CB2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjBARUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBARUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:20:13 -0500
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21FF4F36F;
        Wed,  1 Feb 2023 09:20:09 -0800 (PST)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-16346330067so24419855fac.3;
        Wed, 01 Feb 2023 09:20:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvS6IzC8bwewPncy4ABn16veV+Ux4xgWqkXAqCcyLxY=;
        b=i1ymH9eG1KTE8s//6Zg7bEKO+1EgQlH+OSfPTDFvkT+Ph3XWGefVK4qwuBR/817YaM
         6w3TyXA9HBVCgxg8ECWlbopFV2zDwYXOdh5edKivDeOpyZBy+Kz9Tddd3ecGF9S8Hth5
         +d1M7kI+pGGnEfHf10WE89bxfUU9Bkg9qKUfdB1CI9KuE4qGzXryIAubC+wUGP5/mMCv
         qlCkeVSLDeZiNgBxv/gMCEfhpIAyBInhFniNcouU266Mcq+8NXsBTFS7qzxbQ0PCgUj9
         p6qjoYp4kDkQu5QMS7MWCrRL+G3b/QN3kqnleMEquKnPF9dUEwo8D6vpUrH22PLVzpaU
         +Bdw==
X-Gm-Message-State: AO0yUKUHqUlcZgVrhZgeyRuGN5XoWxF0rdxxsphBaxsxhvXheJJVtlQo
        6ohjlCdS0uWIFLBO4OXcTA==
X-Google-Smtp-Source: AK7set/BDnVzkpsE8Teoq5qX/sm2jzdvxGaWqxAltLjnnVeHkNBTa305CN2wWkzToMcN1ClyGheccg==
X-Received: by 2002:a05:6871:28e:b0:166:732f:243b with SMTP id i14-20020a056871028e00b00166732f243bmr1364046oae.52.1675272009003;
        Wed, 01 Feb 2023 09:20:09 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q42-20020a05687082aa00b001676a4dc22bsm1312853oae.58.2023.02.01.09.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 09:20:08 -0800 (PST)
Received: (nullmailer pid 3750008 invoked by uid 1000);
        Wed, 01 Feb 2023 17:20:07 -0000
Date:   Wed, 1 Feb 2023 11:20:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Youghandhar Chintala <quic_youghand@quicinc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt: bindings: add dt entry for XO calibration
 support
Message-ID: <20230201172007.GA3733090-robh@kernel.org>
References: <20230131140345.6193-1-quic_youghand@quicinc.com>
 <20230131140345.6193-2-quic_youghand@quicinc.com>
 <622ef51f-643e-5eb5-3884-3f22bf4fa9be@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <622ef51f-643e-5eb5-3884-3f22bf4fa9be@linaro.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 07:02:16PM +0100, Krzysztof Kozlowski wrote:
> On 31/01/2023 15:03, Youghandhar Chintala wrote:
> > Add dt binding to get XO calibration data support for Wi-Fi RF clock.
> 
> Use subject prefixes matching the subsystem (which you can get for
> example with `git log --oneline -- DIRECTORY_OR_FILE` on the directory
> your patch is touching).
> Hint: dt-bindings: net: qcom,ath11k:
> 
> > 
> > Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
> > ---
> >  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml         | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > index f7cf135aa37f..205ee949daba 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> > @@ -41,6 +41,10 @@ properties:
> >          * reg
> >          * reg-names
> >  
> > +  xo-cal-data:
> > +    description:
> > +      XO cal offset to be configured in XO trim register
> 
> Missing type. I also do not understand what's this and why some register
> offset should be stored in DT. Please give us some justification why
> this is suitable for DT.

I think that's a voltage offset or something, but you are right, we 
shouldn't have to guess.

It needs a vendor prefix, too.

Rob
