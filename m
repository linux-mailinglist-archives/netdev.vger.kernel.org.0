Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6009628EB96
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgJODeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgJODeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 23:34:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D5622241;
        Thu, 15 Oct 2020 03:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602732858;
        bh=TVGjhdWiB2fFA3Y1jyQm7Z4EccfRhDmqHc1Qnp5+ouk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UD8c268b7z7PxWnzhwPftXHLw4gqiynlEH3lAPHx3vRzAfcSeHISXTkHpQTRyzgDB
         VJ7kqMwdQ3bAWuqhhhjJGM+RFN5g82d4q4tAEFe121iQ6MdZ3FGPDOmKa9LJkV+QVZ
         fwUOe+/yxEEdt2JE31rBCn0xsojs/nPX6MSM2u00=
Date:   Wed, 14 Oct 2020 20:34:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv3 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201014203416.6e0a1604@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 15:27:25 +0800 Xin Long wrote:
> Description From the RFC:
> 
>    The Main Reasons:
> 
>    o  To allow SCTP traffic to pass through legacy NATs, which do not
>       provide native SCTP support as specified in [BEHAVE] and
>       [NATSUPP].
> 
>    o  To allow SCTP to be implemented on hosts that do not provide
>       direct access to the IP layer.  In particular, applications can
>       use their own SCTP implementation if the operating system does not
>       provide one.

Marcelo, Neil - please review if you want this one to make 5.10.

Otherwise we can defer until after the merge window.
