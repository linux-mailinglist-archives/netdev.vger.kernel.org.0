Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884D7DDFBF
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfJTRbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:31:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfJTRbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 13:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8/FgQ2qacImKMxlWmdpp/nzPExDuTmWm1fED5Z0j8aM=; b=wy6uaHP/9FisXodnPwPLUDXnKT
        HX7CqSteITEo49vZlOcfXDXb2Jw06berXaPOLs7vXw4PpEPJrW0ga7/xbVLQsi8SkOB+cNEDCBTPV
        lr5DOPD1PbgEfq7f24MWGCDcTc+QjsOf6egyof8gkPqK1qN4BDrcWiS+9t/JdfpeT5H8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMF2m-00019j-2Z; Sun, 20 Oct 2019 19:31:04 +0200
Date:   Sun, 20 Oct 2019 19:31:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191020173104.GB3080@lunn.ch>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
 <20191019210202.GN2185@nanopsycho>
 <20191019211234.GH25148@lunn.ch>
 <20191020055459.GO2185@nanopsycho>
 <20191020060246.GP2185@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020060246.GP2185@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 08:02:46AM +0200, Jiri Pirko wrote:
> Sun, Oct 20, 2019 at 07:54:59AM CEST, jiri@resnulli.us wrote:
> >Sat, Oct 19, 2019 at 11:12:34PM CEST, andrew@lunn.ch wrote:
> >>> Could you please follow the rest of the existing params?
> >>
> >>Why are params special? Devlink resources can and do have upper case
> >>characters. So we get into inconsistencies within devlink,
> >>particularly if there is a link between a parameter and a resources.
> >
> >Well, only for netdevsim. Spectrum*.c resources follow the same format.
> >I believe that the same format should apply on resources as well.
> >
> 
> Plus reporters, dpipes follow the same format too. I'm going to send
> patches to enforce the format there too.

Hi Jiri

I'm pretty much against this. This appears to be arbitrary. There is
no technical reason, other than most users so far have kept to lower
case. But in general, the kernel does not impose such restrictions.

Ethtool statistics are mixed case.
Interface names are mixed case.
/dev devices are mixed case.
Namespaces are mixed case.
All HWMON properties and names are mixed case.
Interrupt names are mixed case.
IIO names are mixed case.
etc.

Apart from the FAT filesystem, can you think of any places in the
kernel which enforce lower case? And if so, why does it impose lower
case?

       Andrew
