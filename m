Return-Path: <netdev+bounces-2043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6397000B4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7D2E1C2112B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA5363B2;
	Fri, 12 May 2023 06:40:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F1137F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:40:49 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECCFDC47
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:40:32 -0700 (PDT)
X-QQ-mid: bizesmtp84t1683873625tuelmh5q
Received: from smtpclient.apple ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 12 May 2023 14:40:24 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: W+onFc5Tw4MHy2VTxc3Q3lX0Ij7doXQ02w+5OvkxFYjc4DsY+fwNw5/Z2rdD7
	aP9G/V395p4cM1QYbxPLtgNP4YFc5I0BdGckENv0o9Dcn/oZKa4I9QyYGMr5Kg/WSvpxDwE
	F9SbOEDtiTGaZRjCH9VTl1B/EKA5HcKDhxoHJo2/sKlTodSgv23zZEla0Rjg/sG+gblK8oK
	ZPQXI8X/oG1ITLe5pfOx++g/4oXiwOmIdtuPxg82FGKcHNiGcMcsiO2MPfsEMEdPU9u/5hh
	MtY7ntUWFcL5B5NaCWHZibx7Q22DqFW9L6dLIw1p/ixg6Oj5e1JyUzsOU/3lM8UiCEuDGZG
	p9urGAi3DLrwk0uzVfUz4RdDRthAE+sj/WlrUWtnsLcULXBMs5otWJ3XrWwReLtR9HtE+h6
	1ahOExwdfFk=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 1145219249041509278
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v4 3/7] net: wangxun: Implement vlan add and kill
 functions
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <c7ec9d3d-c8da-0b9a-2420-fa9031074613@huawei.com>
Date: Fri, 12 May 2023 14:40:13 +0800
Cc: netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <41F205C3-8826-4855-AB77-61E8F81AC40C@net-swift.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-4-mengyuanlou@net-swift.com>
 <c7ec9d3d-c8da-0b9a-2420-fa9031074613@huawei.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B45=E6=9C=8811=E6=97=A5 20:21=EF=BC=8CYunsheng Lin =
<linyunsheng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 2023/5/10 17:38, Mengyuan Lou wrote:
>> Implement vlan add/kill functions which add and remove
>> vlan id in hardware.
>>=20
>> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
>> ---
>> drivers/net/ethernet/wangxun/libwx/wx_hw.c   | 275 =
++++++++++++++++++-
>> drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   3 +
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c  |  18 ++
>> drivers/net/ethernet/wangxun/libwx/wx_type.h |  31 +++
>> 4 files changed, 326 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c =
b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
>> index ca409b4054d0..4b7baeb6c568 100644
>> --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
>> +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
>> @@ -1182,12 +1182,30 @@ static void wx_enable_sec_rx_path(struct wx =
*wx)
>> WX_WRITE_FLUSH(wx);
>> }
>>=20
>> +static void wx_vlan_strip_control(struct wx *wx, bool enable)
>> +{
>> + int i, j;
>> +
>> + for (i =3D 0; i < wx->num_rx_queues; i++) {
>> + struct wx_ring *ring =3D wx->rx_ring[i];
>> +
>> + if (ring->accel)
>> + continue;
>=20
> Nit: add a blane line here?
>=20
>> + j =3D ring->reg_idx;
>> + wr32m(wx, WX_PX_RR_CFG(j), WX_PX_RR_CFG_VLAN,
>> +      enable ? WX_PX_RR_CFG_VLAN : 0);
>> + }
>> +}
>> +
>> void wx_set_rx_mode(struct net_device *netdev)
>> {
>> struct wx *wx =3D netdev_priv(netdev);
>> + netdev_features_t features;
>> u32 fctrl, vmolr, vlnctrl;
>> int count;
>>=20
>> + features =3D netdev->features;
>> +
>> /* Check for Promiscuous and All Multicast modes */
>> fctrl =3D rd32(wx, WX_PSR_CTL);
>> fctrl &=3D ~(WX_PSR_CTL_UPE | WX_PSR_CTL_MPE);
>> @@ -1254,6 +1272,13 @@ void wx_set_rx_mode(struct net_device *netdev)
>> wr32(wx, WX_PSR_VLAN_CTL, vlnctrl);
>> wr32(wx, WX_PSR_CTL, fctrl);
>> wr32(wx, WX_PSR_VM_L2CTL(0), vmolr);
>> +
>> + if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
>> +    (features & NETIF_F_HW_VLAN_STAG_RX))
>> + wx_vlan_strip_control(wx, true);
>> + else
>> + wx_vlan_strip_control(wx, false);
>=20
> Is there any reason not check features bits in the
> ndev->ndo_set_features?
>=20
Will add undo_set_features later, cover wx_set_rx_mode.

>> +
>> }
>> EXPORT_SYMBOL(wx_set_rx_mode);
>>=20
>> @@ -1462,6 +1487,16 @@ static void wx_configure_tx(struct wx *wx)
>>      WX_MAC_TX_CFG_TE, WX_MAC_TX_CFG_TE);
>> }
>>=20
>> +static void wx_restore_vlan(struct wx *wx)
>> +{
>> + u16 vid =3D 1;
>> +
>> + wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), 0);
>> +
>> + for_each_set_bit_from(vid, wx->active_vlans, VLAN_N_VID)
>> + wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), vid);
>> +}
>> +
>> /**
>>  * wx_configure_rx - Configure Receive Unit after Reset
>>  * @wx: pointer to private structure
>> @@ -1527,7 +1562,7 @@ void wx_configure(struct wx *wx)
>> wx_configure_port(wx);
>>=20
>> wx_set_rx_mode(wx->netdev);
>> -
>> + wx_restore_vlan(wx);
>> wx_enable_sec_rx_path(wx);
>>=20
>> wx_configure_tx(wx);
>> @@ -1727,4 +1762,242 @@ int wx_sw_init(struct wx *wx)
>> }
>> EXPORT_SYMBOL(wx_sw_init);
>>=20
>> +/**
>> + *  wx_find_vlvf_slot - find the vlanid or the first empty slot
>> + *  @wx: pointer to hardware structure
>> + *  @vlan: VLAN id to write to VLAN filter
>> + *
>> + *  return the VLVF index where this VLAN id should be placed
>> + *
>> + **/
>> +static int wx_find_vlvf_slot(struct wx *wx, u32 vlan)
>> +{
>> + u32 bits =3D 0, first_empty_slot =3D 0;
>> + int regindex;
>> +
>> + /* short cut the special case */
>> + if (vlan =3D=3D 0)
>> + return 0;
>> +
>> + /* Search for the vlan id in the VLVF entries. Save off the first =
empty
>> + * slot found along the way
>> + */
>> + for (regindex =3D 1; regindex < WX_PSR_VLAN_SWC_ENTRIES; =
regindex++) {
>> + wr32(wx, WX_PSR_VLAN_SWC_IDX, regindex);
>> + bits =3D rd32(wx, WX_PSR_VLAN_SWC);
>> + if (!bits && !(first_empty_slot))
>> + first_empty_slot =3D regindex;
>> + else if ((bits & 0x0FFF) =3D=3D vlan)
>> + break;
>> + }
>> +
>> + if (regindex >=3D WX_PSR_VLAN_SWC_ENTRIES) {
>> + if (first_empty_slot)
>> + regindex =3D first_empty_slot;
>> + else
>> + regindex =3D -ENOMEM;
>> + }
>> +
>> + return regindex;
>> +}
>> +
>> +/**
>> + *  wx_set_vlvf - Set VLAN Pool Filter
>> + *  @wx: pointer to hardware structure
>> + *  @vlan: VLAN id to write to VLAN filter
>> + *  @vind: VMDq output index that maps queue to VLAN id in VFVFB
>> + *  @vlan_on: boolean flag to turn on/off VLAN in VFVF
>> + *  @vfta_changed: pointer to boolean flag which indicates whether =
VFTA
>> + *                 should be changed
>> + *
>> + *  Turn on/off specified bit in VLVF table.
>> + **/
>> +static int wx_set_vlvf(struct wx *wx, u32 vlan, u32 vind, bool =
vlan_on,
>> +       bool *vfta_changed)
>> +{
>> + u32 vt;
>> +
>> + /* If VT Mode is set
>> + *   Either vlan_on
>> + *     make sure the vlan is in VLVF
>> + *     set the vind bit in the matching VLVFB
>> + *   Or !vlan_on
>> + *     clear the pool bit and possibly the vind
>> + */
>> + vt =3D rd32(wx, WX_CFG_PORT_CTL);
>> + if (vt & WX_CFG_PORT_CTL_NUM_VT_MASK) {
>=20
> Maybe reduce one indentation by:
>=20
> if(!vt & WX_CFG_PORT_CTL_NUM_VT_MASK)
> return;
>=20
>> + s32 vlvf_index;
>> + u32 bits;
>> +
>> + vlvf_index =3D wx_find_vlvf_slot(wx, vlan);
>> + if (vlvf_index < 0)
>> + return vlvf_index;
>> +
>> + wr32(wx, WX_PSR_VLAN_SWC_IDX, vlvf_index);
>> + if (vlan_on) {
>> + /* set the pool bit */
>> + if (vind < 32) {
>> + bits =3D rd32(wx, WX_PSR_VLAN_SWC_VM_L);
>> + bits |=3D (1 << vind);
>> + wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
>> + } else {
>> + bits =3D rd32(wx, WX_PSR_VLAN_SWC_VM_H);
>> + bits |=3D (1 << (vind - 32));
>> + wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
>> + }
>> + } else {
>> + /* clear the pool bit */
>> + if (vind < 32) {
>> + bits =3D rd32(wx, WX_PSR_VLAN_SWC_VM_L);
>> + bits &=3D ~(1 << vind);
>> + wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
>> + bits |=3D rd32(wx, WX_PSR_VLAN_SWC_VM_H);
>> + } else {
>> + bits =3D rd32(wx, WX_PSR_VLAN_SWC_VM_H);
>> + bits &=3D ~(1 << (vind - 32));
>> + wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
>> + bits |=3D rd32(wx, WX_PSR_VLAN_SWC_VM_L);
>> + }
>> + }
>> +
>> + if (bits) {
>> + wr32(wx, WX_PSR_VLAN_SWC, (WX_PSR_VLAN_SWC_VIEN | vlan));
>> + if (!vlan_on && vfta_changed)
>> + *vfta_changed =3D false;
>> + } else {
>> + wr32(wx, WX_PSR_VLAN_SWC, 0);
>> + }
>> + }
>> +
>> + return 0;
>> +}
>> +
>=20
> ...
>=20
>> +
>> struct wx_ring {
>> struct wx_ring *next;           /* pointer to next ring in q_vector =
*/
>> struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
>> struct net_device *netdev;      /* netdev ring belongs to */
>> struct device *dev;             /* device for DMA mapping */
>> + struct wx_fwd_adapter *accel;
>=20
> It seems accel is not really necessary for this patch, as
> it is only checked wx_vlan_strip_control().

Thanks.
>=20
>=20
>=20


