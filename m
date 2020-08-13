Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7322224388A
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 12:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHMKbh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 06:31:37 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:35289 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbgHMKbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 06:31:35 -0400
Received: from [37.161.87.136] (port=46755 helo=[192.168.42.162])
        by hostingweb31.netsons.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <luca@lucaceresoli.net>)
        id 1k6AW9-000FlW-5k; Thu, 13 Aug 2020 12:31:29 +0200
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
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
References: <20200812203618.2656699-1-robh@kernel.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <d5808e9c-07fe-1c28-b9a6-a16abe9df458@lucaceresoli.net>
Date:   Thu, 13 Aug 2020 12:31:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812203618.2656699-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 12/08/20 22:36, Rob Herring wrote:
> Clean-up incorrect indentation, extra spaces, long lines, and missing
> EOF newline in schema files. Most of the clean-ups are for list
> indentation which should always be 2 spaces more than the preceding
> keyword.
> 
> Found with yamllint (which I plan to integrate into the checks).

[...]

> diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> index 3d4e1685cc55..28c6461b9a9a 100644
> --- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> +++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
> @@ -95,10 +95,10 @@ allOf:
>        # Devices without builtin crystal
>        properties:
>          clock-names:
> -            minItems: 1
> -            maxItems: 2
> -            items:
> -              enum: [ xin, clkin ]
> +          minItems: 1
> +          maxItems: 2
> +          items:
> +            enum: [ xin, clkin ]
>          clocks:
>            minItems: 1
>            maxItems: 2

Thanks for noticing, LGTM.

[...]

> diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> index d7dac16a3960..36dc7b56a453 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> @@ -33,8 +33,8 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/uint32
>  
>    touchscreen-min-pressure:
> -    description: minimum pressure on the touchscreen to be achieved in order for the
> -                 touchscreen driver to report a touch event.
> +    description: minimum pressure on the touchscreen to be achieved in order
> +      for the touchscreen driver to report a touch event.

Out of personal taste, I find the original layout more pleasant and
readable. This third option is also good, especially for long descriptions:

  description:
    minimum pressure on the touchscreen to be achieved in order for the
    touchscreen driver to report a touch event.

At first glance yamllint seems to support exactly these two by default:

> With indentation: {spaces: 4, check-multi-line-strings: true}
> 
> the following code snippet would PASS:
> 
> Blaise Pascal:
>     Je vous écris une longue lettre parce que
>     je n'ai pas le temps d'en écrire une courte.
> 
> the following code snippet would PASS:
> 
> Blaise Pascal: Je vous écris une longue lettre parce que
>                je n'ai pas le temps d'en écrire une courte.
> 
> the following code snippet would FAIL:
> 
> Blaise Pascal: Je vous écris une longue lettre parce que
>   je n'ai pas le temps d'en écrire une courte.
> 
(https://yamllint.readthedocs.io/en/stable/rules.html#module-yamllint.rules.indentation)


-- 
Luca

