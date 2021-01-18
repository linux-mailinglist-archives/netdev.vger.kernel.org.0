Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB842FA8EC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407679AbhARSdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407667AbhARSdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F8322CA2;
        Mon, 18 Jan 2021 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610994755;
        bh=1yjuMhFuz1zFDmnEJbai/9WGtEZ7VVPt2Fx7tTd/QM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=im6Abq6WjSBqxPOhPEMXP54FKd2/217WNMZc3OB1gE2rTf4ENRr6EzuMtPGSpccxH
         9ySeR8Ga7Xp4Ta7+ZyxlaVJABwBHJeECiaGdYBpG3cKEvC4RuJla0v65FcDxo5yxUf
         ADTVKikbKNf5FBAqFlNdtxreyulgpGbksaB15noHRu577o0sN6HGIkJmJKFe490yyB
         xbCz5rPP3+GvCe21ZIGxm6yuDxBD55R2C8zhsXVzKIawEGGem4WaIG+jimhMXJ5/0z
         D6gka6FeVv9rcEVcGzzOW9fGid/kLLTpP0l6I8D5I3+L9hvIPdwIbP1tPRa2Zj5vq2
         YPkPfwLvNpKVg==
Date:   Mon, 18 Jan 2021 10:32:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        edwin.verplanke@intel.com
Subject: Re: [PATCH net-next 0/4] i40e: small improvements on XDP path
Message-ID: <20210118103233.49bfd205@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ8uoz3YSuPj6F+GHkk6yXHryUEOUhVSg2pDVEVrFA6b8Hgu6g@mail.gmail.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
        <CAJ8uoz3YSuPj6F+GHkk6yXHryUEOUhVSg2pDVEVrFA6b8Hgu6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 08:31:23 +0100 Magnus Karlsson wrote:
> On Thu, Jan 14, 2021 at 3:34 PM Cristian Dumitrescu
> <cristian.dumitrescu@intel.com> wrote:
> >
> > This patchset introduces some small and straightforward improvements
> > to the Intel i40e driver XDP path. Each improvement is fully described
> > in its associated patch.
> 
> Thank you for these clean ups Cristian!
> 
> For the series:
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

FWIW since this series is 100% driver code I'm expecting it will 
come downstream via Tony's tree. Please LMK if that's not the case.
