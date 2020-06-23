Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51C520688D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbgFWXjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387651AbgFWXjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 19:39:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E52520780;
        Tue, 23 Jun 2020 23:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592955539;
        bh=xKT/js2v/JgI645NCQNpgAlusZxsFQ8L0dQ/LKFKdPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eI85S543nlAy97r41tojp7Oif0X+Koup9hrBgaP6chFz2aprDZiTX3FkuTYMG3M1y
         6DdyMk2iQV9dMiwa1RVXLjCyQn9N+FC+zcHHjzprrfTX2K9UzsIkC8e6qswtBX3fTs
         RG6UqT5RbpA63uuVLX+6m19e1YqpLWt2bA3WBt3Y=
Date:   Tue, 23 Jun 2020 16:38:57 -0700
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
Subject: Re: [net-next v2 15/15] idpf: Introduce idpf driver
Message-ID: <20200623163857.4e3c219c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623224043.801728-16-jeffrey.t.kirsher@intel.com>
References: <20200623224043.801728-1-jeffrey.t.kirsher@intel.com>
        <20200623224043.801728-16-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 15:40:43 -0700 Jeff Kirsher wrote:
> +/**
> + * idpf_probe - Device initialization routine
> + * @pdev: PCI device information struct
> + * @ent: entry in idpf_pci_tbl
> + *
> + * Returns 0 on success, negative on failure
> + */
> +int idpf_probe(struct pci_dev *pdev,
> +	       const struct pci_device_id __always_unused *ent)


drivers/net/ethernet/intel/idpf/idpf_main.c:46:5: warning: symbol 'idpf_probe' was not declared. Should it be static?
drivers/net/ethernet/intel/idpf/idpf_main.c:46:5: warning: no previous prototype for idpf_probe [-Wmissing-prototypes]
   46 | int idpf_probe(struct pci_dev *pdev,
      |     ^~~~~~~~~~
