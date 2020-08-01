Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4E9235465
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 23:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHAV2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 17:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgHAV2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 17:28:02 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B70DBC06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 14:28:01 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 071LR31E069253;
        Sat, 1 Aug 2020 23:27:03 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 071LR3UW012987;
        Sat, 1 Aug 2020 23:27:03 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 071LR2Ja012983;
        Sat, 1 Aug 2020 23:27:02 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Sat, 1 Aug 2020 23:27:02 +0200
User-Agent: KMail/1.9.10
Cc:     c.emde@osadl.org, devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        wg@grandegger.com, davem@davemloft.net, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz> <20200103235359.GA23875@bogus> <202007290112.32007.pisa@cmp.felk.cvut.cz>
In-Reply-To: <202007290112.32007.pisa@cmp.felk.cvut.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008012327.02185.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 071LR31E069253
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
        score=-1.235, required 6, autolearn=not spam, BAYES_00 -0.50,
        KHOP_HELO_FCRDNS 0.21, NICE_REPLY_A -0.95, SPF_HELO_NONE 0.00,
        SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1596922028.72396@tRCbrGj+PxUvk141JZjhxg
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob ad others,

On Wednesday 29 of July 2020 01:12:31 Pavel Pisa wrote:
> On Saturday 04 of January 2020 00:53:59 Rob Herring wrote:
> > On Sat, Dec 21, 2019 at 03:07:31PM +0100, pisa@cmp.felk.cvut.cz wrote:
> > > From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > >
> > > Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > > ---
> > >  .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61
> > > ++++++++++++++++++++++ 1 file changed, 61 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
> >
> > Bindings are moving DT schema format now. Not something I'd require on a
> > respin I've already reviewed, but OTOH it's been 10 months to respin
> > from v2. So:
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> >
> > If you have a v4, then please convert to a schema.
>

...

> I am trying to resolve that only one review feedback which I have received
> before v4 patches sending. I have spent half day to update and integrate
> self build packages to my stable Debian to can run
>
>    make -k dt_binding_check
>
> but unfortunately, I have not achieved promissing result even when tested
> on Linux kernel unpatched sources. I used actual git
> dt-schema/dt-doc-validate with 5.4 kernel build but I get only long series
> of

I have succeed to run make dt_binding_check on stable Debian with 5.4
kernel with only denumerable bunch of errors, probably normal one.
Details to make dt_binding_check usable on stable Debian later.

When invoked with base directory specified

/usr/local/bin/dt-doc-validate -u /usr/src/linux-5.4/Documentation/devicetree/bindings/ net/can/ctu,ctucanfd.yaml

then no problem is reported in ctu,ctucanfd.yaml .
Please is the specification correct even after human check?

> pi@baree:/usr/src/linux-5.4-rt/_build/arm/px6$ make dt_binding_check -k
> GNUmakefile:40: *** mixed implicit and normal rules: deprecated syntax
> make -C /usr/src/linux-5.4-rt O=/usr/src/linux-5.4-rt/_build/arm/px6/
> ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- QTDIR=/usr/share/qt4
> dt_binding_check CHKDT   Documentation/devicetree/bindings/arm/actions.yaml
> /usr/src/linux-5.4-rt/Documentation/devicetree/bindings/arm/actions.yaml: 
> found incompatible YAML document in "<unicode string>", line 2, column 1
> make[3]: ***

The remark to save time of others, actual stable Debian Buster provides package
python3-ruamel.yaml in 0.15.34-1+b1 version. But use of make dt_binding_check
and dt-doc-validate and dt-validate with this version lead to many errors
"found incompatible YAML document". The validation tools can be make
to work when next packages are added and replaced in stable Debian

python3-pyrsistent 0.15.5-1
python3-pyfakefs 4.0.2-1
python3-zipp 1.0.0-3
python3-importlib-metadata 1.6.0
python3-jsonschema 3.2.0-3
python3-ruamel.yaml.clib 0.2.0-3
python3-ruamel.yaml 0.16.10-2

The dependencies and interdependence of the tools are really wide and that
the tools are unusable in the actual regular Debian stable distribution
should be described somewhere visible enough to save developers
time.

Best wishes,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://dce.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/

