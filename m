Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49832A32D
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382046AbhCBIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344576AbhCBF2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 00:28:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6321560241;
        Tue,  2 Mar 2021 05:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614662863;
        bh=5F27m4NsFLCUr7CLSJiPMlsnMXQ+sltkofLgIHPnvGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sNq9+65I1HXIDlREZBMnYg0SwjfK3umjU/oEuXmJs9hYOtNenvsnkGQhqdAarWTUE
         jONksSscb8Hoc6fMza0R+IqX+3Oq3Qeb/dJaZa+/VMCaoOPM1CYbWG85cwX2IjQHwu
         /uwXSKChGR+VIGjEGWv4jSDXc1o0NQCkv6+Pde7Q=
Date:   Tue, 2 Mar 2021 06:27:39 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] e1000e: use proper #include guard name in hw.h
Message-ID: <YD3Myz2psace5IqO@kroah.com>
References: <20210227095858.604463-1-gregkh@linuxfoundation.org>
 <df502c9f145e8ca26d7c79f291fc7abd48066b88.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df502c9f145e8ca26d7c79f291fc7abd48066b88.camel@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 01:37:59AM +0000, Nguyen, Anthony L wrote:
> On Sat, 2021-02-27 at 10:58 +0100, Greg Kroah-Hartman wrote:
> > The include guard for the e1000e and e1000 hw.h files are the same,
> > so
> > add the proper "E" term to the hw.h file for the e1000e driver.
> 
> There's a patch in process that addresses this issue [1].

Thanks, hopefully it gets fixed somehow :)

greg k-h
