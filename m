Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6663820B8AC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgFZSwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFZSwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 14:52:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DCC20836;
        Fri, 26 Jun 2020 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593197558;
        bh=iWFGnTUMBy5jEWdjP4Wb4tXOuu/oc8hUGUE0klrSI88=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lnL3Phi01ORIp2PvyLTKRUAtq29pFwyoSU4RD/h4vbKJNymsMmdocPuR4iPGVgDJF
         OZDujZoE3wr4jjDVvXmlhJ14x9t+06Vdrv52pd2NdRedI7YkT9sXQkZDyi7qE77MBX
         2q8rXUCQe2jtQIUUIvRi9v7IvGXnfmzFOPKIR8DA=
Date:   Fri, 26 Jun 2020 11:52:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alan Brady <alan.brady@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [net-next v3 15/15] idpf: Introduce idpf driver
Message-ID: <20200626115236.7f36d379@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:37 -0700 Jeff Kirsher wrote:
> +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");

Corporations do not author things, people do. Please drop this.
