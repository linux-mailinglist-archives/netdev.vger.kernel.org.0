Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A364358C4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJUDEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:04:42 -0400
Received: from out10.migadu.com ([46.105.121.227]:53008 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhJUDEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 23:04:41 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2021 23:04:41 EDT
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634784811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FZI/suxCWksYSV2TZOx89MblgpL1R04FJyLzdqHA0Jg=;
        b=A356h4EjFqpCrBOSKPvVYmpjZXFibzy2J9HwZk0d8AcRiSxPit3P7M4s4r1WljZGw11CZ6
        ajSHGXyaR2fd37pNX9/AiF81qUOR0dAR4HjfJ5I6VaaGYuhVFeD+DfrsOnyPInKXhdsuk6
        ieDTrNxCJI9GWL3IH64NYpoET7cK5VY=
Date:   Thu, 21 Oct 2021 02:53:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yanjun.zhu@linux.dev
Message-ID: <a3770ad64d2232cbdc19f86bc4e42a16@linux.dev>
Subject: Re: [PATCH 1/1] ice: remove the unused function
 ice_aq_nvm_update_empr
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org
In-Reply-To: <adf52e0ca3fbe0c9726f283a9690bd335afbf3a6.camel@intel.com>
References: <adf52e0ca3fbe0c9726f283a9690bd335afbf3a6.camel@intel.com>
 <20211019091743.12046-1-yanjun.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yanjun.zhu@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

October 21, 2021 2:49 AM, "Nguyen, Anthony L" <anthony.l.nguyen@intel.com=
> wrote:=0A=0A> On Tue, 2021-10-19 at 05:17 -0400, yanjun.zhu@linux.dev w=
rote:=0A> =0A>> From: Zhu Yanjun <yanjun.zhu@linux.dev>=0A>> =0A>> The fu=
nction ice_aq_nvm_update_empr is not used, so remove it.=0A> =0A> Thanks =
for the patch, but there is another one coming soon that will be=0A> usin=
g this function[1]. I'd prefer to keep this to save us from another=0A> p=
atch reintroducing it in the near future.=0A=0AGot it.=0A=0AZhu Yanjun=0A=
=0A> =0A> Thanks,=0A> Tony=0A> =0A> [1] https://patchwork.ozlabs.org/proj=
ect/intel-wired-=0A> lan/patch/20211019215423.3383750-1-jacob.e.keller@in=
tel.com/=0A> =0A>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>=0A>> =
---=0A>> drivers/net/ethernet/intel/ice/ice_nvm.c | 16 ----------------=
=0A>> drivers/net/ethernet/intel/ice/ice_nvm.h |  1 -=0A>> 2 files change=
d, 17 deletions(-)=0A>> =0A>> diff --git a/drivers/net/ethernet/intel/ice=
/ice_nvm.c=0A>> b/drivers/net/ethernet/intel/ice/ice_nvm.c=0A>> index fee=
37a5844cf..bad374bd7ab3 100644=0A>> --- a/drivers/net/ethernet/intel/ice/=
ice_nvm.c=0A>> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c=0A>> @@ -11=
06,22 +1106,6 @@ enum ice_status ice_nvm_write_activate(struct=0A>> ice_h=
w *hw, u8 cmd_flags)=0A>> return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL=
);=0A>> }=0A>> =0A>> -/**=0A>> - * ice_aq_nvm_update_empr=0A>> - * @hw: p=
ointer to the HW struct=0A>> - *=0A>> - * Update empr (0x0709). This comm=
and allows SW to=0A>> - * request an EMPR to activate new FW.=0A>> - */=
=0A>> -enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)=0A>> -{=
=0A>> -       struct ice_aq_desc desc;=0A>> -=0A>> -       ice_fill_dflt_=
direct_cmd_desc(&desc,=0A>> ice_aqc_opc_nvm_update_empr);=0A>> -=0A>> -  =
     return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);=0A>> -}=0A>> -=0A>=
> /* ice_nvm_set_pkg_data=0A>> * @hw: pointer to the HW struct=0A>> * @de=
l_pkg_data_flag: If is set then the current pkg_data store by=0A>> FW=0A>=
> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h=0A>> b/drivers/ne=
t/ethernet/intel/ice/ice_nvm.h=0A>> index c6f05f43d593..925225905491 1006=
44=0A>> --- a/drivers/net/ethernet/intel/ice/ice_nvm.h=0A>> +++ b/drivers=
/net/ethernet/intel/ice/ice_nvm.h=0A>> @@ -39,7 +39,6 @@ enum ice_status=
=0A>> ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct=0A>> =
ice_sq_cd *cd);=0A>> enum ice_status ice_nvm_validate_checksum(struct ice=
_hw *hw);=0A>> enum ice_status ice_nvm_write_activate(struct ice_hw *hw, =
u8=0A>> cmd_flags);=0A>> -enum ice_status ice_aq_nvm_update_empr(struct i=
ce_hw *hw);=0A>> enum ice_status=0A>> ice_nvm_set_pkg_data(struct ice_hw =
*hw, bool del_pkg_data_flag, u8=0A>> *data,=0A>> u16 length, struct ice_s=
q_cd *cd);
