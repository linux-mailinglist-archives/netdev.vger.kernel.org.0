Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F422A456
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbgGWBHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728607AbgGWBHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 21:07:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7096B2080D;
        Thu, 23 Jul 2020 01:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595466427;
        bh=1VFl9IJDc5ykHtFXUz/H6WJhm/E+LHMsfh6Ehr4Ah8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yooHWeoXLeldVh4T+OzVFQ7r0/qVV57Ia3MueI1OlRw9tGezje+DxzHQug3i+EJWN
         YzTxsm5D2fBNF/UY6yKyaZd7+UswdtxtK/M1ZoRdmO1amNz/YEQAJu14emxYrf9J8i
         pyDjPTisTa+SODq3002eAWYznC+aumPRsGjTXy+M=
Date:   Wed, 22 Jul 2020 18:07:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
Cc:     "Wang, Haiyue" <haiyue.wang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 00:37:29 +0000 Venkataramanan, Anirudh wrote:
> Can you please clarify how you (and the community) define bifurcated
> driver?

No amount of clarification from me will change the fact that you need
this for DPDK.
