Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C4D2818A6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbgJBRFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388161AbgJBRFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:30 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605FE20795;
        Fri,  2 Oct 2020 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601658329;
        bh=zkEkRwtoOaXtnq/Sk9c8Njba4l/VLi3Gw2Ab+MPEUvk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CIO9lZDdSMigYjbs5mdoYWk0ZyfIFJ0jWSR+fJnbxBCOZA9dy6xd7ptpSrTv5Lf91
         Eq4r/kBNA7EXBP+qrFGSTCelZ2qZ9rRTbDnTdAK+/WAq+PwYP1Dg1kiqKKfmXnMlAx
         DWLAGNMTaUQcVQ7/V/etplegxBBOJoA6kmyoySWk=
Message-ID: <99f02abd0894928f09f683fd54b033b03f7eac20.camel@kernel.org>
Subject: Re: [net V2 07/15] net/mlx5: Fix request_irqs error flow
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Date:   Fri, 02 Oct 2020 10:05:28 -0700
In-Reply-To: <20201001162459.7214ed69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001195247.66636-1-saeed@kernel.org>
         <20201001195247.66636-8-saeed@kernel.org>
         <20201001162459.7214ed69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 16:24 -0700, Jakub Kicinski wrote:
> On Thu,  1 Oct 2020 12:52:39 -0700 saeed@kernel.org wrote:
> > -	for (; i >= 0; i--) {
> > +	for (--i; i >= 0; i--) {
> 
> while (i--)

while(--i)

I like this, less characters to maintain :)

