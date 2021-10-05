Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374434233CB
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhJEWsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:48:02 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:42821 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbhJEWr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:47:59 -0400
Received: by mail-oi1-f171.google.com with SMTP id x124so1358397oix.9;
        Tue, 05 Oct 2021 15:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=idk/OPLqOoxicS++8eNcVOO+4pet2v6UE8sH+4Sn+Fs=;
        b=WyTt2CQ9yJFlHGsC8zVMPHHvq5DXj31iv+UOO1BmXHi63+boxFKUna0r6qh0YTQY1/
         M6TlUdbENjmP7LKGWBkuEjexUxmMNRskHJcy8eU4pYWnCYPzV/Fs/ilhnlQbyID86q5a
         hvadqI9on0eHQYE6O2A0GT2ydrplUF0O10uZd25G56AjOs/rAZ7lU/mqGC3Io6kjssSg
         sekxx0qnJLKGOTterNuzRs8zgl217lLuLxLGt14WiOShWd8U8Fn7urS4M+9uiUvILwQA
         B8TU7Fnns99SfJyDaEBZfWzSpF9TDVV0hlB1T1uOtZX/EitPCyLKOSA+/GFJnXrALjir
         Xzog==
X-Gm-Message-State: AOAM533xb7Cko15KkCkvj0LbQF//I+SDLs5IsG8PlTuU/rz11d6CEkgn
        aOTdNXsO68c5Zfxs7/t/HQ==
X-Google-Smtp-Source: ABdhPJzuCyAG5KCu9OI9pzfAoSNtgTk0/nwWINbsvAaJKNhig4buPmUm2PEwS2D8Cwi0GfG/C6nvPw==
X-Received: by 2002:aca:2415:: with SMTP id n21mr4542248oic.27.1633473967660;
        Tue, 05 Oct 2021 15:46:07 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a9sm3775851otk.3.2021.10.05.15.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 15:46:06 -0700 (PDT)
Received: (nullmailer pid 106780 invoked by uid 1000);
        Tue, 05 Oct 2021 22:45:59 -0000
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devel@driverdev.osuosl.org,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
In-Reply-To: <20211005135400.788058-3-Jerome.Pouiller@silabs.com>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com> <20211005135400.788058-3-Jerome.Pouiller@silabs.com>
Subject: Re: [PATCH v8 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Tue, 05 Oct 2021 17:45:59 -0500
Message-Id: <1633473959.392405.106778.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Oct 2021 15:53:38 +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Prepare the inclusion of the wfx driver in the kernel.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 137 ++++++++++++++++++
>  1 file changed, 137 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml:39:31: [error] syntax error: mapping values are not allowed here (syntax)

dtschema/dtc warnings/errors:
make[1]: *** Deleting file 'Documentation/devicetree/bindings/net/wireless/silabs,wfx.example.dts'
Traceback (most recent call last):
  File "/usr/local/bin/dt-extract-example", line 45, in <module>
    binding = yaml.load(open(args.yamlfile, encoding='utf-8').read())
  File "/usr/local/lib/python3.8/dist-packages/ruamel/yaml/main.py", line 434, in load
    return constructor.get_single_data()
  File "/usr/local/lib/python3.8/dist-packages/ruamel/yaml/constructor.py", line 120, in get_single_data
    node = self.composer.get_single_node()
  File "_ruamel_yaml.pyx", line 706, in _ruamel_yaml.CParser.get_single_node
  File "_ruamel_yaml.pyx", line 724, in _ruamel_yaml.CParser._compose_document
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 891, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 904, in _ruamel_yaml.CParser._parse_next_event
ruamel.yaml.scanner.ScannerError: mapping values are not allowed in this context
  in "<unicode string>", line 39, column 31
make[1]: *** [Documentation/devicetree/bindings/Makefile:20: Documentation/devicetree/bindings/net/wireless/silabs,wfx.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
./Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml:  mapping values are not allowed in this context
  in "<unicode string>", line 39, column 31
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml: ignoring, error parsing file
warning: no schema found in file: ./Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
make: *** [Makefile:1441: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1536655

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

