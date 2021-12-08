Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D172746D494
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhLHNsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:48:03 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:39731 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLHNsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:48:02 -0500
Received: by mail-ot1-f50.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso2756768ots.6;
        Wed, 08 Dec 2021 05:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=R3u0Jcq+1B2bYajxbvWH6IM09BiTGDSY3O2hAAldlZg=;
        b=TT308n322+aZP4foGi1c1B98n+fdEQmxiXotEa26fI2hcTzFrxQ1HzrFYo3xF1wPoT
         S1WPkb4tSyuSj92/s4G/oXT7frgcO9VdmIa080xJTLgK2Q0DR4EK6nuFvH7uS8GGsHpS
         FVlqlq7x9igZxMEYvtSq9LXCqjcaby26FEq3z1oHn8hJwqM/LyZLdSmVr1n4L5MBxLlf
         0K2jwkSphDtGOwu7csaT7uWySbP6XanzoCy+61f6974bo387NfrFAQEN6MmFv3jd+VGc
         PUwo59gOjfb7O5m/A3FL1j+EPV/8BT6k42AVSieHDuWErYVKTmGw1Aqlf3CHrdSVyMoY
         /MYA==
X-Gm-Message-State: AOAM530z7A1vCuur+tJJtAbQ84mlwpQvcJ+9qaoyND0n1d7pyrmzj1H9
        vTSrPfKlCgzTcr5NQsAGuMGd//G+xw==
X-Google-Smtp-Source: ABdhPJzEQAjqqEGZTfISEAmYosVzB9TyjiJ4GChjsHU0BlHDB8tVJohP9sTIWYNuIGclEQr55whIGA==
X-Received: by 2002:a9d:7a8c:: with SMTP id l12mr40072823otn.84.1638971070238;
        Wed, 08 Dec 2021 05:44:30 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id m12sm673427oiw.23.2021.12.08.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 05:44:29 -0800 (PST)
Received: (nullmailer pid 3857723 invoked by uid 1000);
        Wed, 08 Dec 2021 13:44:28 -0000
From:   Rob Herring <robh@kernel.org>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
In-Reply-To: <20211202204656.4411-2-josright123@gmail.com>
References: <20211202204656.4411-1-josright123@gmail.com> <20211202204656.4411-2-josright123@gmail.com>
Subject: Re: [PATCH 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Wed, 08 Dec 2021 07:44:28 -0600
Message-Id: <1638971068.694210.3857722.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021 04:46:55 +0800, Joseph CHANG wrote:
> For support davicom dm9051 device tree configuration
> 
> Signed-off-by: Joseph CHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/davicom,dm9051.yaml:62:7: [error] no new line character at the end of file (new-line-at-end-of-file)

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/davicom,dm9051.example.dts:29.34-35 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:373: Documentation/devicetree/bindings/net/davicom,dm9051.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1413: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):
Documentation/Makefile:39: The 'sphinx-build' command was not found. Make sure you have Sphinx installed and in PATH, or set the SPHINXBUILD make variable to point to the full path of the 'sphinx-build' executable.

Detected OS: DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS".
Warning: better to also install "convert".
Warning: better to also install "dot".
Warning: better to also install "dvipng".
ERROR: please install "ensurepip", otherwise, build won't work.
Warning: better to also install "fonts-dejavu".
Warning: better to also install "fonts-noto-cjk".
Warning: better to also install "latexmk".
Warning: better to also install "rsvg-convert".
Warning: better to also install "xelatex".
You should run:

	sudo apt-get install imagemagick graphviz dvipng python3-venv fonts-dejavu fonts-noto-cjk latexmk librsvg2-bin texlive-xetex
note: If you want pdf, you need at least Sphinx 2.4.4.
To upgrade Sphinx, use:

Can't build as 2 mandatory dependencies are missing at ./scripts/sphinx-pre-install line 953.
	/usr/bin/python3 -m venv sphinx_2.4.4
	. sphinx_2.4.4/bin/activate
	pip install -r ./Documentation/sphinx/requirements.txt

If you want to exit the virtualenv, you can use:
	deactivate

See https://patchwork.ozlabs.org/patch/1565174

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

