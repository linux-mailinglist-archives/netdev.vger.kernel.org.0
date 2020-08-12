Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488062430CC
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 00:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgHLWck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 18:32:40 -0400
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:41486 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726605AbgHLWcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 18:32:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id C315D100E7B65;
        Wed, 12 Aug 2020 22:32:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6742:6743:7875:9010:10004:10400:10848:11232:11233:11657:11658:11914:12043:12109:12297:12555:12740:12760:12895:12986:13069:13311:13357:13439:14096:14097:14181:14581:14659:14721:21080:21121:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:5,LUA_SUMMARY:none
X-HE-Tag: board29_4d052b526fef
X-Filterd-Recvd-Size: 2655
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 12 Aug 2020 22:32:33 +0000 (UTC)
Message-ID: <f5dedf2d8d8057de3eaa2f9126f44cebb0653b09.camel@perches.com>
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
From:   Joe Perches <joe@perches.com>
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Wed, 12 Aug 2020 15:32:32 -0700
In-Reply-To: <20200812203618.2656699-1-robh@kernel.org>
References: <20200812203618.2656699-1-robh@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-12 at 14:36 -0600, Rob Herring wrote:
> Clean-up incorrect indentation, extra spaces, long lines, and missing
> EOF newline in schema files. Most of the clean-ups are for list
> indentation which should always be 2 spaces more than the preceding
                                     ^
> keyword.
[]
> diff --git a/Documentation/devicetree/bindings/arm/arm,integrator.yaml b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> index 192ded470e32..f0daf990e077 100644
> --- a/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> +++ b/Documentation/devicetree/bindings/arm/arm,integrator.yaml
> @@ -67,9 +67,9 @@ patternProperties:
>        compatible:
>          items:
>            - enum:
> -            - arm,integrator-ap-syscon
> -            - arm,integrator-cp-syscon
> -            - arm,integrator-sp-syscon
> +              - arm,integrator-ap-syscon
> +              - arm,integrator-cp-syscon
> +              - arm,integrator-sp-syscon

Confused a bit here.
          - enum:
	10 spaces to dash
old line:
            - arm,integrator-ap-syscon
	12 spaces to dash
new line:
              - arm,integrator-ap-syscon
	14 spaces to dash

Is it supposed to be 2 spaces more than the preceding line
or 4 more?


