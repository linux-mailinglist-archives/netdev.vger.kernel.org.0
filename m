Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9924719DA
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 12:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhLLLrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 06:47:47 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48763 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhLLLrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 06:47:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id DC49F5801BD;
        Sun, 12 Dec 2021 06:47:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 Dec 2021 06:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=i68MDK
        OYZX2L9llnoC4vHRarKh+UThKV0LjDM1g07oQ=; b=WWTaJ1GlXONzJOmCl9jtBJ
        UlLm8ZGJPtay2MOsaLg//hvfIixS1FkreC9+VQ0iq9N5hTqrSI7GMtcAmhDYdXk9
        hceH7qVeRdKj+sv5bKJEJx6S0Cxvmg7VCYZSOPe/Hhmytu8Ihx+sibjZ4s/MMj7i
        /YPRcTpWLnj8c6ca6LtZkSmJLzwTnGTNzZUirQbu0fQUKkGelmwfxh2L916hRR06
        t46mXPLEEKPoHeW7k4drW5wCNyeB281aMEkmqbuU1Y3pMPm8DjvJwgYBNG5QkhjU
        sOXgC2PdM0g2qzZZwI6mQHO6Ab6mDW542+hqaTOf5yUkCIa3SNckaAxtFtUEV7xQ
        ==
X-ME-Sender: <xms:YeG1YXMNwpUn57dofbEG3zB1q9TrtLHCfDxRk-K2iXBbMgCuocvP3Q>
    <xme:YeG1YR8or4MOq2d2C9voM3k_pJEA0ax5TtoL5lAYUTamOve54j1GByn1SCWnsxTsM
    OAh6-C4GDFDOBU>
X-ME-Received: <xmr:YeG1YWRHlEVLA5oG5jsbsOXIqFAu86wryeUEIW-8LD_g7OrZxbR0zzzvSXS5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YeG1YbupWaUEWO5JIPN-b0TeibR3tR5Uz348pnFfO9CfOmzz7NQIsg>
    <xmx:YeG1YfcKU9RsVJgV3uyS03dG5K9jTJtOyQruSb5foxxK5KGxBhvmEw>
    <xmx:YeG1YX0x0NGiyJIecJpgR-XfMirfwFNDGdQ2e5pGVFEWeQjuwFcK5w>
    <xmx:YeG1YX2deXHOhMO9tPxp92PslBPfQo2ZNObbxto-p3njfMb96p0yhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Dec 2021 06:47:44 -0500 (EST)
Date:   Sun, 12 Dec 2021 13:47:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        arkadiusz.kubalewski@intel.com, richardcochran@gmail.com,
        abyagowi@fb.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        kuba@kernel.org, linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com, petrm@nvidia.com
Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Message-ID: <YbXhXstRpzpQRBR8@shredder>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 02:45:46PM +0100, Maciej Machnikowski wrote:
> Synchronous Ethernet networks use a physical layer clock to syntonize
> the frequency across different network elements.
> 
> Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> Equipment Clock (EEC) and have the ability to synchronize to reference
> frequency sources.
> 
> This patch series is a prerequisite for EEC object and adds ability
> to enable recovered clocks in the physical layer of the netdev object.
> Recovered clocks can be used as one of the reference signal by the EEC.

The dependency is the other way around. It doesn't make sense to add
APIs to configure the inputs of an object that doesn't exist. First add
the EEC object, then we can talk about APIs to configure its inputs from
netdevs.

With these four patches alone, user space doesn't know how many EECs
there are in the system, it doesn't know the mapping from netdev to EEC,
it doesn't know the state of the EEC, it doesn't know which source is
chosen in case more than one source is enabled. Patch #3 tries to work
around it by having ice print to kernel log, when the information should
really be exposed via the EEC object.

+		dev_warn(ice_pf_to_dev(pf),
+			 "<DPLL%i> state changed to: %d, pin %d",
+			 ICE_CGU_DPLL_SYNCE,
+			 pf->synce_dpll_state,
+			 pin);

> 
> Further work is required to add the DPLL subsystem, link it to the
> netdev object and create API to read the EEC DPLL state.

When the EEC object materializes, we might find out that this API needs
to be changed / reworked / removed, but we won't be able to do that
given it's uAPI. I don't know where the confidence that it won't happen
stems from when there are so many question marks around this new
object.

> 
> v5:
> - rewritten the documentation
> - fixed doxygen headers
> 
> v4:
> - Dropped EEC_STATE reporting (TBD: DPLL subsystem)
> - moved recovered clock configuration to ethtool netlink
> 
> v3:
> - remove RTM_GETRCLKRANGE
> - return state of all possible pins in the RTM_GETRCLKSTATE
> - clarify documentation
> 
> v2:
> - improved documentation
> - fixed kdoc warning
> 
> RFC history:
> v2:
> - removed whitespace changes
> - fix issues reported by test robot
> v3:
> - Changed naming from SyncE to EEC
> - Clarify cover letter and commit message for patch 1
> v4:
> - Removed sync_source and pin_idx info
> - Changed one structure to attributes
> - Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
>   to the recovered clock of a port that returns the state
> v5:
> - add EEC source as an optiona attribute
> - implement support for recovered clocks
> - align states returned by EEC to ITU-T G.781
> v6:
> - fix EEC clock state reporting
> - add documentation
> - fix descriptions in code comments
> 
> 
> Maciej Machnikowski (4):
>   ice: add support detecting features based on netlist
>   ethtool: Add ability to configure recovered clock for SyncE feature
>   ice: add support for monitoring SyncE DPLL state
>   ice: add support for recovered clocks
> 
>  Documentation/networking/ethtool-netlink.rst  |  62 ++++
>  drivers/net/ethernet/intel/ice/ice.h          |   7 +
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  70 ++++-
>  drivers/net/ethernet/intel/ice/ice_common.c   | 224 +++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_common.h   |  20 +-
>  drivers/net/ethernet/intel/ice/ice_devids.h   |   3 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  96 +++++++
>  drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.c      |  35 +++
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  49 ++++
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  36 +++
>  drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>  include/linux/ethtool.h                       |   9 +
>  include/uapi/linux/ethtool_netlink.h          |  21 ++
>  net/ethtool/Makefile                          |   3 +-
>  net/ethtool/netlink.c                         |  20 ++
>  net/ethtool/netlink.h                         |   4 +
>  net/ethtool/synce.c                           | 267 ++++++++++++++++++
>  18 files changed, 929 insertions(+), 4 deletions(-)
>  create mode 100644 net/ethtool/synce.c
> 
> -- 
> 2.26.3
> 
