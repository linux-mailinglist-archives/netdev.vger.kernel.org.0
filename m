Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE2549BD5
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343713AbiFMSkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343707AbiFMSkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA18E50070;
        Mon, 13 Jun 2022 08:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E915B81022;
        Mon, 13 Jun 2022 15:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C6CC34114;
        Mon, 13 Jun 2022 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655134119;
        bh=Dya8+t1QAtJ3oxTE/w7JBXY3Zy4dSxKdD4rHdX/ukpU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W+9bwBPVa6gi1WBdJnbOZQ9otuTgRa+uQlfgJjus5ISO4CQoKszfbzn/2ujRSDS9w
         YU5R9bYYkgqU5tFuUOWjLWOVA5BmosI9eYXKhxos+SrBcSuHyxQ0CFNGAcSW5YkEKZ
         CKnrAWrLDnLKjoEPb6e+1TWmduzAzsSgmyUHhBjr9+hps+tSaZQXWk8EVyZ06PCU2z
         kdb1Ht0264pqgRRMsIQi/OGqeG+CdxpiKjLHUrwNXX0HGDqzsyf588udukbhcTCNwX
         QlQJPHq3iyBQMnESw/1crRKvxxikenY0sgNBGrHHXH003Fsbx+4bV88jEQ5qcTpUHK
         Sp1Xoinc1NUUA==
Received: by mail-vs1-f54.google.com with SMTP id x187so6274652vsb.0;
        Mon, 13 Jun 2022 08:28:39 -0700 (PDT)
X-Gm-Message-State: AJIora8AiJUlxK+NHA6QtueF+s4KwJGW8g+J9i53p2uTiMAYjwVmA87Z
        H49E5TNT+64q8bkwAZY03+7PSkv5l0yKOvQqtg==
X-Google-Smtp-Source: AGRyM1umgaHpMsDuaM9Lw94TfUrdKW7JXHhr0M5N07BAWPFzL5Dd/52HH45wQ0ShL4JTzWTYPX1477u063LUFx5tJoE=
X-Received: by 2002:a67:d38c:0:b0:349:d028:c8ea with SMTP id
 b12-20020a67d38c000000b00349d028c8eamr133392vsj.6.1655134118163; Mon, 13 Jun
 2022 08:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610165940.2326777-6-jiaqing.zhao@linux.intel.com> <1654903146.313095.2450355.nullmailer@robh.at.kernel.org>
 <21c9ba6b-e84e-4545-44d2-5ffe5fea9581@linux.intel.com>
In-Reply-To: <21c9ba6b-e84e-4545-44d2-5ffe5fea9581@linux.intel.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Jun 2022 09:28:26 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+y3tkfLV8UpUe6jw7Fq7YDrzwoq3FKK4jeeZEBOxhM4g@mail.gmail.com>
Message-ID: <CAL_Jsq+y3tkfLV8UpUe6jw7Fq7YDrzwoq3FKK4jeeZEBOxhM4g@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] dt-bindings: net: Add NCSI bindings
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 9:09 PM Jiaqing Zhao
<jiaqing.zhao@linux.intel.com> wrote:
>
> On 2022-06-11 07:19, Rob Herring wrote:
> > On Sat, 11 Jun 2022 00:59:39 +0800, Jiaqing Zhao wrote:
> >> Add devicetree bindings for NCSI VLAN modes. This allows VLAN mode to
> >> be configured in devicetree.
> >>
> >> Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
> >> ---
> >>  .../devicetree/bindings/net/ncsi.yaml         | 34 ++++++++++++++++++=
+
> >>  MAINTAINERS                                   |  2 ++
> >>  include/dt-bindings/net/ncsi.h                | 15 ++++++++
> >>  3 files changed, 51 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/ncsi.yaml
> >>  create mode 100644 include/dt-bindings/net/ncsi.h
> >>
> >
> > My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_chec=
k'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> >
> > yamllint warnings/errors:
> >
> > dtschema/dtc warnings/errors:
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/ne=
t/ncsi.yaml: 'oneOf' conditional failed, one must be fixed:
> >       'unevaluatedProperties' is a required property
> >       'additionalProperties' is a required property
> >       hint: Either unevaluatedProperties or additionalProperties must b=
e present
> >       from schema $id: http://devicetree.org/meta-schemas/core.yaml#
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/ne=
t/ncsi.yaml: ignoring, error in schema:
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/ne=
t/ncsi.example.dtb: ethernet@1e660000: 'ncsi,vlan-mode' does not match any =
of the regexes
> >       From schema: /builds/robherring/linux-dt-review/Documentation/dev=
icetree/bindings/vendor-prefixes.yaml
>
> I saw vendor-prefix.yaml says do not add non-vendor prefixes to the list.=
 Since "ncsi" is not a vendor, may I ask what is the suggested replacement =
for 'ncsi,vlan-mode'? Will 'ncsi-vlan-mode' be fine?

I don't know. What is NCSI? Is it specific to certain MACs? Why do you
need to set this up in DT? Network configuration is typically done in
userspace, so putting VLAN config in DT doesn't seem right. All
questions your commit message should answer.

>
> > Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/=
ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast=
2600-mac', 'faraday,ftgmac100']
> > Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/=
ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast=
2600-mac', 'faraday,ftgmac100']
>
> The ftgmac100 it depends on uses a txt document instead of an yaml schema=
. And I see there is other schemas having the same error, can this be ignor=
ed?

No. Don't add to the list. Once all the existing warnings (~40) are
fixed, then this will be turned on by default.

>
> And I've got one more question. The ncsi driver does not has its own comp=
atible field, instead, it is enabled by setting the "use-ncsi" property of =
some specific mac drivers. Though currently only ftgmac100 supports ncsi in=
 upstream kernel, it may be used by other mac drivers in the future. What d=
o you think is a proper way for defining the ncsi schema? Having it in a se=
parate yaml like this patch or add the properties to all the mac yamls that=
 supports yaml? If the former way is preferred, how should the schema be de=
fined without "compatible"?

If it is a function of driver support or not, then it doesn't belong in DT.

Rob
