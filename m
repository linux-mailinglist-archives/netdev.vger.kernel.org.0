Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752CB64A5AE
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiLLRQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLLRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:16:04 -0500
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04695DF85;
        Mon, 12 Dec 2022 09:16:04 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id z14-20020a9d65ce000000b0067059c25facso7687441oth.6;
        Mon, 12 Dec 2022 09:16:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQuMESS15iL+keqb+arvVwzmgQV/IA9/9TzRWzljLqY=;
        b=bt/dPiX6JLBDvOeca+W2+sV3Kwrbg8+5z746RqpIn/C2j5LH00ePkTN1hebU2clO6G
         cZhlu5YK4D+BUvcN7VLNJGw9pfu7EwITWy/w41pEPWeZwRtg0r5jR9940ewvM4Pt6Kya
         A1j28zFWe4c87h2q94MPne7T6d754SNDqgAqKoQtU8xyPfsVNyRUj2mIzJJDRauB0CF4
         pccPwrlHTqRpgHJW/XaCpU+sdmMiBvO5ouRNezVsWR7cSGZEMAJnVPI1+xfkc+hV34Fy
         Acpyg9vesrtg5U/nuKIJKYOAK6ER8u7EQAPOGToOI+soOGYUEtOcxhwi/qooiadHHqgk
         /hJQ==
X-Gm-Message-State: ANoB5pmbdNh589/jq04ctu1VmWI9YmaoUwY+N4nSlEwRtCgC8umSBGXk
        HouaW76yYAX7/ZHvmNOyuA==
X-Google-Smtp-Source: AA0mqf5oE4vtCGON//oOoKCEuAIcBYHgFtQQLaKQHYeqC1mFDfg8Tg3Xyc4CaP3L6jze7AtH9KRnww==
X-Received: by 2002:a05:6830:18d2:b0:669:3637:45ee with SMTP id v18-20020a05683018d200b00669363745eemr7019523ote.3.1670865363037;
        Mon, 12 Dec 2022 09:16:03 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s6-20020a0568302a8600b00660e833baddsm163070otu.29.2022.12.12.09.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 09:16:02 -0800 (PST)
Received: (nullmailer pid 1151527 invoked by uid 1000);
        Mon, 12 Dec 2022 17:16:01 -0000
Date:   Mon, 12 Dec 2022 11:16:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: hellcreek: Sync DSA
 maintainers
Message-ID: <167086536034.1151448.11436062856944671032.robh@kernel.org>
References: <20221212081546.6916-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212081546.6916-1-kurt@linutronix.de>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 12 Dec 2022 09:15:46 +0100, Kurt Kanzenbach wrote:
> The current DSA maintainers are Florian Fainelli, Andrew Lunn and Vladimir
> Oltean. Update the hellcreek binding accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
