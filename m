Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB94138FF0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAMLUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:20:41 -0500
Received: from mx4.wp.pl ([212.77.101.11]:46321 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgAMLUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 06:20:41 -0500
Received: (wp-smtpd smtp.wp.pl 24510 invoked from network); 13 Jan 2020 12:20:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578914439; bh=eF/JKh5FKeOw6oXd1ISCT/pJWk9xuIxNv1dDpFd5VXw=;
          h=From:To:Cc:Subject;
          b=tDciLlzZEzzT/oBfWsrQxnnVfyZVrVIrGQkc9/AMPAl+nGp9X21iMdnhh3SJs1d6x
           Jmjmt+5XLBIQXFk7jueDPj753iaf5jq8EiKinjqpF22EBXdlag1HGZEDcb5TQ6wj7f
           L3UxqCzbHz1sOWTWr0G5HOol0vUc9ehpjBpy94YQ=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jinpu.wang@cloud.ionos.com>; 13 Jan 2020 12:20:38 +0100
Date:   Mon, 13 Jan 2020 03:20:30 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>, tariqt@mellanox.com,
        "David S. Miller" <davem@davemloft.net>, kernel-team@fb.com
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
Message-ID: <20200113032030.2fc9d891@cakuba>
In-Reply-To: <CAMGffEntn9nQAUk5ejEiEfnSjGda20rqQVi-zNu+GFr3v39pAA@mail.gmail.com>
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
        <20200112125055.512b65f6@cakuba>
        <CAMGffEntn9nQAUk5ejEiEfnSjGda20rqQVi-zNu+GFr3v39pAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: c869d747557a2131b45ee9da26a4aebd
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [UeOk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 09:47:59 +0100, Jinpu Wang wrote:
> On Sun, Jan 12, 2020 at 9:51 PM Jakub Kicinski <kubakici@wp.pl> wrote:
> > On Thu, 9 Jan 2020 11:23:17 -0800, Jonathan Lemon wrote:  
> > > On modern hardware with a large number of cpus and using XDP,
> > > the current MSIX limit is insufficient.  Bump the limit in
> > > order to allow more queues.
> > >
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>  
> >
> > Applied to net-next, thanks everyone!
> >
> > (Jack, please make sure you spell your tags right)  
> Checked, It's correct both in my reply and in net-next.git.

I manually corrected it in tree. You swapped 'i' and 'e' 
in the word reviewed, your email had "reveiwed".
