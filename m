Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EA523DD54
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgHFRIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729390AbgHFRGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:06:34 -0400
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [IPv6:2001:718:2:1611:0:1:0:70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B77BEC002154
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 08:54:46 -0700 (PDT)
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 076Frg7D045971;
        Thu, 6 Aug 2020 17:53:42 +0200 (CEST)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 076FrfBn002665;
        Thu, 6 Aug 2020 17:53:41 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 076FrfWs002664;
        Thu, 6 Aug 2020 17:53:41 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 2/6] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
Date:   Thu, 6 Aug 2020 17:53:40 +0200
User-Agent: KMail/1.9.10
Cc:     Pavel Machek <pavel@ucw.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org, mkl@pengutronix.de,
        socketcan@hartkopp.net, wg@grandegger.com, davem@davemloft.net,
        mark.rutland@arm.com, c.emde@osadl.org, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz> <20200804092021.yd3wisz3g2ed6ioe@duo.ucw.cz> <20200806144713.GA829771@bogus>
In-Reply-To: <20200806144713.GA829771@bogus>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008061753.40832.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 076Frg7D045971
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-0.1,
        required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1597334025.32967@lL+aMP+/PLx5Ni1jQOKRFQ
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel and Rob,

thanks much for review.

On Thursday 06 of August 2020 16:47:13 Rob Herring wrote:
> On Tue, Aug 04, 2020 at 11:20:21AM +0200, Pavel Machek wrote:
> > On Tue 2020-08-04 11:18:17, Pavel Machek wrote:
> > > Hi!
> > >
> > > > The commit text again to make checkpatch happy.
> > >
> > > ?

The checkpatch reports as a problem when there is no description
of the patch. At least for patch

  [PATCH v4 1/6] dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.

I consider that little pontificate but I have fullfiled its suggestion
with remark, that in this case, It is not my intention to add these
promotions. I remove the reference to patchcheck from these commit messages.

> > > > +    oneOf:
> > > > +      - items:
> > > > +          - const: ctu,ctucanfd
> > > > +          - const: ctu,canfd-2
> > > > +      - const: ctu,ctucanfd
> > >
> > > For consistency, can we have ctu,canfd-1, ctu,canfd-2?
> >
> > Make it ctu,ctucanfd-1, ctu,ctucanfd-2... to make it consistent with
> > the file names.
>
> If you are going to do version numbers, please define where they come
> from. Hopefully some tag of the h/w IP version...
>
> Better yet, put version numbers in the h/w registers itself and you
> don't need different compatibles.

The actual major version of the core is 2. The minor intended
for release was 1. But we wait for driver inclusion and release
and IP core release has not been realized. Sources moved to
2.2-pre version and compiled core reports 2.2 now.
There is added control bit for protocol exception
behavior selection and minor enhancements in sync of standard
and data rate bittimes starts.

Yes, version can be obtained from hardware.
There is magic and version in the first core register.
See 3.1.1 DEVICE_ID section of the manual (page 22/28)

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf

As for the DT identifier we use "ctu,ctucanfd" in more projects already.
Some devices are in the wild now. So I would prefer to keep compatibility
with that name. Other name reflects that this driver is compatible with major
version 2 of the core. It can be "ctu,ctucanfd-2". I am not sure if the
repeat of "ctu" is good idea, but yes, full sources prefix is "ctucanfd".
The second alias can be omitted alltogether. But I am not sure, there can
be one day fundamental change between IP core versions which would be better
handled by change of PCI ID and DT ID. It is questionable if attempt to keep
single driver for more too different versions would be more manageable
or convoluted than two fully independent ones. May it be we do not need
to solve that because by that time it would be "ctu,ctucanxl".

At this time, our actual first first choic for the IP core identifier
is ctu,ctucanfd.

As for the pointed description, I would remove them from version 5
according to your reference. My personal one is to keep documentation
(even of actual/local functional setup) directly in the sources and mainline
to find it out when I or somebody else need to recreate or update designs,
my biological memory is already worn out by past events.

I am not sure if I should wait for subsystem maintainers review now
or sent new patches version. I may get to its preparation tommorrow
or may it be later because I want to take some time in
countrysite/mountains.

Best wishes

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

