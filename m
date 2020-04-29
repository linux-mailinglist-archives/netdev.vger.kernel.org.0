Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3E1BE9AE
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgD2VPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:15:53 -0400
Received: from mx4.wp.pl ([212.77.101.12]:14662 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2VPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:15:53 -0400
Received: (wp-smtpd smtp.wp.pl 29331 invoked from network); 29 Apr 2020 23:09:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1588194550; bh=K0AfXvE+F4abj0Lg6AOI9aM6N68iOhpFgqSdXiO4qlU=;
          h=From:To:Cc:Subject;
          b=mbpiv8NTLFgVvGbrbIdq6dwKJZxEU9lK2NbqzN1F7huUQI05t2Dj61lwgA4TWgFK3
           ShVsIY4ZzQHgqa8H1ObpXHBpPFeod9++3VXesgrNCz2XpWJNWKn4IUuOOgUhA1YX8e
           NCQmoZscL8NdL5N4dc93QhOC20vn70cQcN0KkWIY=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.1])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 29 Apr 2020 23:09:10 +0200
Date:   Wed, 29 Apr 2020 14:09:04 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Benjamin Fisher <benjamin.l.fisher@intel.com>
Subject: Re: [net] ice: cleanup language in ice.rst for fw.app
Message-ID: <20200429140904.68123cef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429205950.1906223-1-jacob.e.keller@intel.com>
References: <20200429205950.1906223-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: d7bfef64f8547e5f60cba96125da834c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [kULT]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 13:59:50 -0700 Jacob Keller wrote:
> The documentation for the ice driver around "fw.app" has a spelling
> mistake in variation. Additionally, the language of "shall have a unique
> name" sounds like a requirement. Reword this to read more like
> a description or property.
> 
> Reported-by: Benjamin Fisher <benjamin.l.fisher@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
