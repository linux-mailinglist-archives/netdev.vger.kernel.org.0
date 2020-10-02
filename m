Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A648281932
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbgJBR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBR1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 13:27:24 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36F6206C3;
        Fri,  2 Oct 2020 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601659644;
        bh=dOGjSQSeEjOHmfzbj+cxES7YQNu4apFyvypojHO8mAc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OKKbwkR6AwN2a1vivgM58xRAGSi5i6j364FxBUbT5MnD7brM2eSSwd/tgRhrl3sLI
         CRR/vYpKLjtEutV7JP/7glLiecSTb5kcZ38sMr/M0GHS7xeuCKxNSXQfLmpD4viNRa
         y3hmP4O7gW6X1vB+Ax0LvnHToUzBz+eGLXbfwv4I=
Message-ID: <f50ceebd886f5b083a918e57fdbe0c26024c0f17.camel@kernel.org>
Subject: Re: [net V2 07/15] net/mlx5: Fix request_irqs error flow
From:   Saeed Mahameed <saeed@kernel.org>
To:     Mark Bloch <mbloch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Date:   Fri, 02 Oct 2020 10:27:22 -0700
In-Reply-To: <e66e2680-cef2-b662-45f6-4c31616d3934@nvidia.com>
References: <20201001195247.66636-1-saeed@kernel.org>
         <20201001195247.66636-8-saeed@kernel.org>
         <20201001162459.7214ed69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <99f02abd0894928f09f683fd54b033b03f7eac20.camel@kernel.org>
         <e66e2680-cef2-b662-45f6-4c31616d3934@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 10:19 -0700, Mark Bloch wrote:
> 
> On 10/2/2020 10:05, Saeed Mahameed wrote:
> > On Thu, 2020-10-01 at 16:24 -0700, Jakub Kicinski wrote:
> > > On Thu,  1 Oct 2020 12:52:39 -0700 saeed@kernel.org wrote:
> > > > -	for (; i >= 0; i--) {
> > > > +	for (--i; i >= 0; i--) {
> > > 
> > > while (i--)
> > 
> > while(--i)
> 
> It has to be: while (i--)
> Case of i=0,
> 

woops !

while (i--) it is. 

Thanks Mark.


