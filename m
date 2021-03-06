Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C6732F7D2
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 03:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCFCaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 21:30:35 -0500
Received: from p3plsmtpa12-05.prod.phx3.secureserver.net ([68.178.252.234]:42382
        "EHLO p3plsmtpa12-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhCFCab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 21:30:31 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id IMi4ld3TzrZPFIMi6lWsrK; Fri, 05 Mar 2021 19:30:30 -0700
X-CMAE-Analysis: v=2.4 cv=be2u7MDB c=1 sm=1 tr=0 ts=6042e946
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=HnUYZtbmAAAA:20 a=NW8-NIpsAAAA:8 a=sF2Hq0S-_YJbdP9ujVwA:9
 a=CjuIK1q_8ugA:10 a=FTAPkevyI8KQvgyCdMRv:22 a=BPzZvq435JnGatEyYwdK:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>, <don@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org>       <YDl3f8MNWdZWeOBh@lunn.ch>      <000901d70cb2$b2848420$178d8c60$@thebollingers.org>     <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>     <YD1ScQ+w8+1H//Y+@lunn.ch>      <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org> <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 5 Mar 2021 18:30:27 -0800
Message-ID: <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLgBgnHheQD1wSRRAcnMEPsCilAQ5aicmFNA
Content-Language: en-us
X-CMAE-Envelope: MS4xfN4YfeNScLb4n4eofhupqpAJXrnysvqSFDl20o7mOBFfNLjkY/YlVUGa+1EuEbdzBHFk2XTiv3LO8AQIsKOqIuioMsHXcN38FSakt4Ci0awQeTPEr40r
 rIvlDTW5KousjXSsCwfFeopFYIA4dTtjBlEO6eKgSOQsedTMeqJhJYwcz2nTaW/RZlErVWtP96aV3BHLXPBfRm+rrJBYocsjXCuF015eAJ0fBTZIlRJahg83
 9b096iBO1Yr8QCZwu6WdtMcMf0LrUpvOF1O1xR3zG/qLtHaD198758ZciVUnUVTBhueTIC00/ZMJ26j77ZYr2MkDHI+1nmTaBwej8sMMOAl4rObMw4tcBotf
 QIAs6/BUJsVEcV7Rc/VKojbJLlfBmFon0j5ePOlnB/F0CvAj1ijPyPPdmlLG1nJtog4cLroialwqdg9AZBwNXcQxDJreTZgYz2+pyyXo83oXkhe5BEHpx5er
 ZEQuVO5WI58saSos+fjI/M0QTqUscOl1TV2DeqnD67NuqJovgzxEZiEoZyosHSMxpJ/jAmf/awDbMCMysU8lz/k8MHo3tVO0ZrElhi7vwg/76W+gI9PzYAFP
 Wxe1Jo6sXzPgBtMcdwrTpXQ0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Mar 2021 2:55 PM -0800 Jakub Kicinski wrote:
> On Fri, 5 Mar 2021 11:07:08 -0800 Don Bollinger wrote:
> > Acknowledging your objections, I nonetheless request that optoe be
> > accepted into upstream as an eeprom driver in drivers/misc/eeprom.  It
> > is a legitimate driver, with a legitimate user community, which
> > deserves the benefits of being managed as a legitimate part of the linux
> kernel.
> 
> It's in the best interest of the community to standardize on how we expect
> things to operate. You're free to do whatever you want in your proprietary
> systems but please don't expect us to accept a parallel, in now way
superior
> method of accessing SFPs.

These are not proprietary systems.  The Network Operating Systems that use
optoe are open source projects, Linux based, available on github, and
contributing to the Linux source (see for example
https://github.com/Azure/SONiC).  The switches that these NOSs run on are
open spec systems
(https://www.opencompute.org/wiki/Networking/SpecsAndDesigns).  The fact
that they use the SDK from the switch silicon vendor should not mean they
are banished from the Linux community.

I am proposing acceptance of a commonly used implementation for accessing
SFPs because the one used by the netdev/netlink community does not fit the
architecture of the white box NOS/switch community.  I am not trying to pick
sides, I am trying to make optoe available to both communities, to improve
EEPROM access for both of them.

Don

