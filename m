Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB3B139F96
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgANCo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:44:29 -0500
Received: from mx3.wp.pl ([212.77.101.10]:55492 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgANCo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:44:29 -0500
Received: (wp-smtpd smtp.wp.pl 32298 invoked from network); 14 Jan 2020 03:44:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578969867; bh=5aFC7Is0fNtqECa6YC/zpeTjnGWfrbtH1VCyKocaFBw=;
          h=From:To:Cc:Subject;
          b=a6NLd+mN2bCLObUNxTcI5Y86J3i7gKEhRmupHMeY9RU5BN/T+dsNnsGDW8K78QX94
           yjCJkYV+PiKPmhZVX+6RLYrjzuQyJ3y3AmePQTyGmjfcWSF4p74rg2sriivUHdjC3D
           NDuQtVFmtBfFj0hyYBCZPyYkYToSWv4S7VyIadVQ=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <kristian.evensen@gmail.com>; 14 Jan 2020 03:44:26 +0100
Date:   Mon, 13 Jan 2020 18:44:19 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH net] qmi_wwan: Add support for Quectel RM500Q
Message-ID: <20200113184419.16c0d23f@cakuba>
In-Reply-To: <20200113135740.31600-1-kristian.evensen@gmail.com>
References: <20200113135740.31600-1-kristian.evensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 7beec8fb15439fd580661f449504c764
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [ATME]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 14:57:40 +0100, Kristian Evensen wrote:
> RM500Q is a 5G module from Quectel, supporting both standalone and
> non-standalone modes. The normal Quectel quirks apply (DTR and dynamic
> interface numbers).
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>

Applied to net, thank you!
