Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB5518491
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiECMt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbiECMt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:49:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D21A839;
        Tue,  3 May 2022 05:45:53 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243AHhcD018592;
        Tue, 3 May 2022 12:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=z5pRrwadTvaMNn3IfMVuln6dl3dg7299RmoATTWlzwg=;
 b=D0+Qdgb0wJMI40BA+uEYDB2P6ae4KozbuZ5K2JQhR9fNK/vvaCLl8k/uzHk+kiFMdb7H
 frtHTtYr0bpz3U0IBPVI0yQiqYkMij/Qoal91w/qxWeeTfyH0L7yu9WYWJMH3RduaEWk
 S6cryHXPNrOrbD1mNOGwPNQlFI6C53VncjhyvgIMu1Jg+xG0WtcFVVuOcaCsVeeVCOiR
 0uhyts6SV9au3nINgAaS/hrT/qrRyKsFOW8eEMnTceJ/nZod58M93wWyEA61QO4+KW5i
 9z5ydpwqezzhj4U7nSkKGL5hsRg1/vAaS0NeoTph0IkgsHmgbps2PLUqi8Ikbl+Z9nUM uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu2gx29ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 12:45:28 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 243CT501031317;
        Tue, 3 May 2022 12:45:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu2gx299h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 12:45:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 243CgoEL007825;
        Tue, 3 May 2022 12:45:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3fttcj0kqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 12:45:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 243CjMSU52232586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 May 2022 12:45:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E1005204F;
        Tue,  3 May 2022 12:45:22 +0000 (GMT)
Received: from sig-9-145-89-42.uk.ibm.com (unknown [9.145.89.42])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7FCD85204E;
        Tue,  3 May 2022 12:45:21 +0000 (GMT)
Message-ID: <867e70df01fc938abf93ffa15a3f1989a8fb136b.camel@linux.ibm.com>
Subject: Re: [RFC v2 21/39] net: add HAS_IOPORT dependencies
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:AX.25 NETWORK LAYER" <linux-hams@vger.kernel.org>
Date:   Tue, 03 May 2022 14:45:21 +0200
In-Reply-To: <alpine.DEB.2.21.2205012324130.9383@angie.orcam.me.uk>
References: <20220429135108.2781579-1-schnelle@linux.ibm.com>
         <20220429135108.2781579-36-schnelle@linux.ibm.com>
         <alpine.DEB.2.21.2205012324130.9383@angie.orcam.me.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UXMkE0Jl2bfDY_C86ZbGXUit00mBBjDH
X-Proofpoint-ORIG-GUID: K2hn79ghKwvBH28giVmJiMbz3A6Tgxi4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-03_03,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 mlxlogscore=474 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-05-01 at 23:48 +0100, Maciej W. Rozycki wrote:
> On Fri, 29 Apr 2022, Niklas Schnelle wrote:
> 
> > In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> > not being declared. We thus need to add HAS_IOPORT as dependency for
> > those drivers using them. It also turns out that with HAS_IOPORT handled
> > explicitly HAMRADIO does not need the !S390 dependency and successfully
> > builds the bpqether driver.
> [...]
> > diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
> > index 846bf41c2717..fa3f1e0fe143 100644
> > --- a/drivers/net/fddi/Kconfig
> > +++ b/drivers/net/fddi/Kconfig
> > @@ -29,7 +29,7 @@ config DEFZA
> >  
> >  config DEFXX
> >  	tristate "Digital DEFTA/DEFEA/DEFPA adapter support"
> > -	depends on FDDI && (PCI || EISA || TC)
> > +	depends on FDDI && (PCI || EISA || TC) && HAS_IOPORT
> >  	help
> >  	  This is support for the DIGITAL series of TURBOchannel (DEFTA),
> >  	  EISA (DEFEA) and PCI (DEFPA) controllers which can connect you
> 
>  NAK, this has to be sorted out differently (and I think we discussed it 
> before).
> 
>  The driver works just fine with MMIO where available, so if `inb'/`outb' 
> do get removed, then only parts that rely on port I/O need to be disabled.  
> In fact there's already such provision there in drivers/net/fddi/defxx.c 
> for TURBOchannel systems (CONFIG_TC), which have no port I/O space either:
> 
> #if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> #define dfx_use_mmio bp->mmio
> #else
> #define dfx_use_mmio true
> #endif
> 
> so I guess it's just the conditional that will have to be changed to:
> 
> #ifdef CONFIG_HAS_IOPORT
> 
> replacing the current explicit bus dependency list.  The compiler will 
> then optimise away all the port I/O stuff (though I suspect dummy function 
> declarations may be required for `inb'/`outb', etc.).
> 
>  I can verify a suitable change with a TURBOchannel configuration once the 
> MIPS part has been sorted.
> 
>   Maciej

With dfx_use_mmio changed as you propose above things compile on s390
which previously ran into missing (now __compile_error()) inl() via
dfx_port_read_long() -> dfx_inl() ->  inl().

Looking at the other uses of dfx_use_mmio I notice however that in
dfx_get_bars(), inb() actually gets called when dfx_use_mmio is true.
This happens if dfx_bus_eisa is also true. Now that variable is just
the cached result of DFX_BUS_EISA(dev) which is defined to 0 if
CONFIG_EISA is unset. I'm not 100% sure if going through a local
variable is still considered trivial enough dead code elimination, at
least it works for me™. I did also check the GCC docs and they
explicitly say that __attribute__(error) is supposed to be used when
dead code elimination gets rid of the error paths.

I think we also need a "depends on HAS_IOPORT" for "config HAVE_EISA"
just as I'm adding for "config ISA".

