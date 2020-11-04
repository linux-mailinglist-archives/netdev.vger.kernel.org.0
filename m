Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB7C2A6DB1
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731520AbgKDTP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:15:57 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45408 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgKDTP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 14:15:57 -0500
Received: by mail-ot1-f67.google.com with SMTP id k3so8488354otp.12;
        Wed, 04 Nov 2020 11:15:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xUeu7OjzCkWfl0q9Q0C25b2gAmYnfpfRf6sdmrxWckA=;
        b=rRM4TTTc4LvENo1QxdeVaqhJBEYUiMMzLaGf/8Ex7eFnhAr1o8Vndeqetms8/n8UQn
         8NO806T8W0IvwzeEQTMO1uO3z1E71vDcFtxZGJFrAiyLz3WxD+3KCwZiToQwLDLc/V4q
         0/rVXl02ls7xivvjx9102Bhl2G3XW98WpxUnDLYJWvQeAD66AAqZyq5u0z6L6Ruhi39i
         UhPGR6vVpkdG79F5C4oZiuSKXYJxwZnLosVUzwF4LGGLZSKS9zAnNjX+OsTAAe+AFiRE
         8qSHAtakSgfzmYoZrphQ0SvvkcJWaczwEjtaXqjBQugFeEfoT0ZdYxvfRn8maAibphWe
         znUQ==
X-Gm-Message-State: AOAM532ovnEl3SOShAV1uAZImHcpsoDCC93Ruw36Vdi0NEB/7vwOR5MB
        JvrMXBqx9sbAeaqQJZz9Fw==
X-Google-Smtp-Source: ABdhPJwyVB6Vxpun9Hwox5/cSocl9xkTao6ENUk5Rm2F/NY+qCi/4EYMETnsGog5AJNAArHDE5FN3w==
X-Received: by 2002:a9d:2283:: with SMTP id y3mr18865146ota.164.1604517355878;
        Wed, 04 Nov 2020 11:15:55 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x21sm660177otk.39.2020.11.04.11.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:15:55 -0800 (PST)
Received: (nullmailer pid 3972960 invoked by uid 1000);
        Wed, 04 Nov 2020 19:15:54 -0000
Date:   Wed, 4 Nov 2020 13:15:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-mmc@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <20201104191554.GA3972736@bogus>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
 <20201104155207.128076-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104155207.128076-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020 16:51:45 +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 131 ++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml: 'additionalProperties' is a required property
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml


See https://patchwork.ozlabs.org/patch/1394182

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

