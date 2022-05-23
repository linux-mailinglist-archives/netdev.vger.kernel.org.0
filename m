Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38D5312B8
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiEWQKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbiEWQKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AA164738
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D73D613FB
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF18C34118
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653322214;
        bh=2dMqjQuf3oXtvpzb3jWcvSkqpMuObKljdZomI7sfWFQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kBkoKOlO5/4W3Pd2Ey5b16dgJQARhKs8D1Mhy1/nLaZY3rQMnI6LJU8ojJci5kiP+
         n/RSUyeqKuEoAgTwveW1GFbX3xZXJwfwff3ACa9BAZkzvfIm/WSs+Zc34TPqo2rp//
         GjwaGYJXzjE1tehNOtAzC624MgBatiWxTP38+B50g9SouM20aaUxhEv1Ey9LvQi5Cp
         R5hI7R1Im7tJgnoMcT0ULAFLXpePclKnbgDSvdxH/mYHP4Dn8x+UFjALlYgTE1cAjh
         Vb9TA1F+s3NwCjlY5KHaThLOjAtHdhvlk+IZFuukQRhuylAhU7SCzltDob7InMYdGT
         pdLzHgtP1aVNw==
Received: by mail-ej1-f50.google.com with SMTP id rs12so18106725ejb.13
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:10:14 -0700 (PDT)
X-Gm-Message-State: AOAM530Us80fB6z2goleZwFQzYxHTJeZuYTAUPErXkqU/hvy8R1i+I7M
        U72WTYhdTEq9NxkEUVAFzP2c2Uraug5gjSwJJQ==
X-Google-Smtp-Source: ABdhPJyw0mq5i9FMhPavQtPw9K4grelB3s3BIYxdh1aM4yiSA8h2F1aGlGZRwROXkO5K74rclRC9abyhTmunmcKM+IU=
X-Received: by 2002:a17:907:3e8f:b0:6fe:d023:e147 with SMTP id
 hs15-20020a1709073e8f00b006fed023e147mr6534613ejc.270.1653322212855; Mon, 23
 May 2022 09:10:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220517085143.3749-1-josua@solid-run.com> <20220517085431.3895-1-josua@solid-run.com>
In-Reply-To: <20220517085431.3895-1-josua@solid-run.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 23 May 2022 11:10:00 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+3seAzJzZZw3AACoWb4dQhB6G1Jtm0ADfCJWtiUWB_5Q@mail.gmail.com>
Message-ID: <CAL_Jsq+3seAzJzZZw3AACoWb4dQhB6G1Jtm0ADfCJWtiUWB_5Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: adin: document phy clock output properties
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev <netdev@vger.kernel.org>, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 3:54 AM Josua Mayer <josua@solid-run.com> wrote:
>
> The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
> well as providing the reference clock on CLK25_REF.
>
> Add DT properties to configure both pins.
>
> Technically the phy also supports a recovered 125MHz clock for
> synchronous ethernet. However SyncE should be configured dynamically at
> runtime, so it is explicitly omitted in this binding.
>
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
> V4 -> V5: removed recovered clock options
> V3 -> V4: changed type of adi,phy-output-reference-clock to boolean
> V1 -> V2: changed clkout property to enum
> V1 -> V2: added property for CLK25_REF pin
>
>  .../devicetree/bindings/net/adi,adin.yaml         | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index 1129f2b58e98..77750df0c2c4 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -36,6 +36,21 @@ properties:
>      enum: [ 4, 8, 12, 16, 20, 24 ]
>      default: 8
>
> +  adi,phy-output-clock:
> +    description: Select clock output on GP_CLK pin. Two clocks are available:

Not valid yaml and now failing in linux-next:

make[1]: *** Deleting file
'Documentation/devicetree/bindings/net/adi,adin.example.dts'
Traceback (most recent call last):
  File "/usr/local/bin/dt-extract-example", line 52, in <module>
    binding = yaml.load(open(args.yamlfile, encoding='utf-8').read())
  File "/usr/local/lib/python3.10/dist-packages/ruamel/yaml/main.py",
line 434, in load
    return constructor.get_single_data()
  File "/usr/local/lib/python3.10/dist-packages/ruamel/yaml/constructor.py",
line 119, in get_single_data
    node = self.composer.get_single_node()
  File "_ruamel_yaml.pyx", line 706, in _ruamel_yaml.CParser.get_single_node
  File "_ruamel_yaml.pyx", line 724, in _ruamel_yaml.CParser._compose_document
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in
_ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in
_ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 891, in
_ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 904, in _ruamel_yaml.CParser._parse_next_event
ruamel.yaml.scanner.ScannerError: mapping values are not allowed in this context
  in "<unicode string>", line 40, column 77
make[1]: *** [Documentation/devicetree/bindings/Makefile:26:
Documentation/devicetree/bindings/net/adi,adin.example.dts] Error 1
./Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error]
syntax error: mapping values are not allowed here (syntax)
./Documentation/devicetree/bindings/net/adi,adin.yaml:  mapping values
are not allowed in this context
  in "<unicode string>", line 40, column 77


You need a '|' for a literal block if you use a colon in the description.

Rob
