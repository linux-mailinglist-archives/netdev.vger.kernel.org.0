Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5927121BEAE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGJUjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgGJUjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:39:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B31B42078B;
        Fri, 10 Jul 2020 20:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594413571;
        bh=EcFydAcb4RjSHLSXM+CCIkUiQE3tEOt9W9PqySvPRng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pYpomhhD/NIzjc5NQK71BWV1W/vjklsxgsNi/2kl3kZmrMYL9tTcIrrUq2q2fpfsP
         GWWhdGQij+mQwee7vCKtHOMMYbtLe0VORt/MtBvem778WG9jqFRINCitvPLpcXzJFC
         eCBJd8U020e6stij8n0vTL3+34YoSn+F4ZIn2IiU=
Date:   Fri, 10 Jul 2020 13:39:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>, moshe@mellanox.com
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
Message-ID: <20200710133929.389f1aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61c8618e-6a82-d28f-4cab-429e4a90bff6@intel.com>
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200630125353.GA2181@nanopsycho>
        <CAACQVJqxLhmO=UiCMh_pv29WP7Qi4bAZdpU9NDk3Wq8TstM5zA@mail.gmail.com>
        <20200701055144.GB2181@nanopsycho>
        <CAACQVJqac3JGY_w2zp=thveG5Hjw9tPGagHPvfr2DM3xL4j_zg@mail.gmail.com>
        <20200701094738.GD2181@nanopsycho>
        <61c8618e-6a82-d28f-4cab-429e4a90bff6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 11:16:51 -0700 Jacob Keller wrote:
> > We already have notion of "a component" in "devlink dev flash". I think
> > that the reset component name should be in-sync with the flash.
> 
> Right. We should re-use the component names from devlink dev info here
> (just as we do in devlink dev flash).

Let's remember that the SW did not eat the entire world just yet ;)

There are still HW components which don't have FW (and therefore FW
component to flash) that folks may want to reset.. that's what the
ethtool reset API was cut to.
