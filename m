Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C72121012A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgGAA71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGAA71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 20:59:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF4E2073E;
        Wed,  1 Jul 2020 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593565166;
        bh=Ui9UkTv18ZcWXFP55iYLYggDlCSoY3bAUhvI0UuixXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mBerGJ06eYMYIbbe2+7hmPOZ0F7N/UXx7o41B7P+638pUc9uTfaJ1V3fuSaIJ1lpD
         dlWnRwtMHJWqIYY+oqaQmHdb2++Hww92PqGiSK637pwbhxwlPSYlugwFdcMiRsrA4u
         cum3/XT2U7liVt7Ar2Si+tk+KvbDb7gjc9FHMVAM=
Date:   Tue, 30 Jun 2020 17:59:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "Brady, Alan" <alan.brady@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Michael, Alice" <alice.michael@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        lkp <lkp@intel.com>
Subject: Re: [net-next v3 15/15] idpf: Introduce idpf driver
Message-ID: <20200630175923.142777be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D9404498743241@ORSMSX112.amr.corp.intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
        <20200626115236.7f36d379@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498743241@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 23:48:34 +0000 Kirsher, Jeffrey T wrote:
> > On Thu, 25 Jun 2020 19:07:37 -0700 Jeff Kirsher wrote:  
> > > +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");  
> > 
> > Corporations do not author things, people do. Please drop this.  
> 
> Your statement makes sense and I know that we have done this
> historically, like several other drivers (not saying it is right).
> The thought process was that our drivers are not written by just one
> or two people, but more like 20+ developers.  So should we list all
> 20+ people that wrote the drivers, or just choose one person?  Also
> what happens when that person no longer works at Intel and the email
> is no longer vaild, should we constantly update the MODULE_AUTHOR()
> to reflect valid employees working on the driver?  That is the reason
> we were using "Intel Corporation" and a valid email that will always
> be good for support questions.

MODULE_AUTHOR() is not required, most of the "documentation" page for
this driver is about where to get support, MAINTAINERS exist..  not to
mention that this is an upstream driver, so posting to netdev is always
appropriate. 

I think we should be covered.
