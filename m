Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A881FF7C7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbgFRPny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731946AbgFRPnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:43:50 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0466A208B8;
        Thu, 18 Jun 2020 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495029;
        bh=1ibcnINZv8eG77joSKFBU1wzkaqF6xe8Oc+cAHc5Xk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXrVQNJDVbNF9l/fqG0JSxfpDH41Z94DL16ZnsoGkYqHJAxwXCfmumd1ADaJSIbll
         gJ/hrAhvPwDIDjFC/O1SXQcefHRoBS6nAtmUu8xRSuBl2nRmR+Hi9lJG5Ar+YB4Mta
         B3Og67D7680KlkJDTMlCbgnl2YzV2RmKWIS/3TK8=
Date:   Thu, 18 Jun 2020 08:43:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next 14/15] iecm: Add iecm to the kernel build system
Message-ID: <20200618084347.21074cf5@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618051344.516587-15-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
        <20200618051344.516587-15-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 22:13:43 -0700 Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
>=20
> This introduces iecm as a module to the kernel, and adds
> relevant documentation.

../drivers/net/ethernet/intel/iecm/iecm_controlq.c:45:17: warning: incorrec=
t type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:45:17:    expected void =
volatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:45:17:    got unsigned c=
har [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:47:17: warning: incorrec=
t type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:47:17:    expected void =
volatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:47:17:    got unsigned c=
har [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:54:9: warning: incorrect=
 type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:54:9:    expected void v=
olatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:54:9:    got unsigned ch=
ar [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:57:9: warning: incorrect=
 type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:57:9:    expected void v=
olatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:57:9:    got unsigned ch=
ar [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:58:9: warning: incorrect=
 type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:58:9:    expected void v=
olatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:58:9:    got unsigned ch=
ar [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:59:9: warning: incorrect=
 type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:59:9:    expected void v=
olatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:59:9:    got unsigned ch=
ar [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:62:15: warning: incorrec=
t type in argument 1 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:62:15:    expected void =
const volatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:62:15:    got unsigned c=
har [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:321:33: warning: incorre=
ct type in assignment (different base types)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:321:33:    expected rest=
ricted __le16 [usertype] pfid_vfid
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:321:33:    got unsigned =
short [usertype] func_id
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:364:9: warning: incorrec=
t type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:364:9:    expected void =
volatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:364:9:    got unsigned c=
har [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:563:17: warning: incorre=
ct type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:563:17:    expected void=
 volatile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:563:17:    got unsigned =
char [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_lib.c:49:13: warning: symbol 'iecm_=
mb_intr_clean' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:70:9: warning: incorrect type=
 in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_lib.c:70:9:    expected void volati=
le [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_lib.c:70:9:    got unsigned char [u=
sertype] *
../drivers/net/ethernet/intel/iecm/iecm_lib.c:63:6: warning: symbol 'iecm_m=
b_irq_enable' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:77:5: warning: symbol 'iecm_m=
b_intr_req_irq' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:104:6: warning: symbol 'iecm_=
get_mb_vec_id' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:122:5: warning: symbol 'iecm_=
mb_intr_init' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:140:6: warning: symbol 'iecm_=
intr_distribute' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:299:21: warning: incorrect ty=
pe in assignment (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_lib.c:299:21:    expected unsigned =
char [usertype] *hw_addr
../drivers/net/ethernet/intel/iecm/iecm_lib.c:299:21:    got void [noderef]=
 <asn:2> *
../drivers/net/ethernet/intel/iecm/iecm_lib.c:417:5: warning: symbol 'iecm_=
vport_rel' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_lib.c:748:6: warning: symbol 'iecm_=
deinit_task' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:84:6: warning: symbol 'iecm_=
tx_buf_rel_all' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:115:6: warning: symbol 'iecm=
_tx_desc_rel' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:136:6: warning: symbol 'iecm=
_tx_desc_rel_all' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:312:6: warning: symbol 'iecm=
_rx_buf_rel_all' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:341:6: warning: symbol 'iecm=
_rx_desc_rel' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:371:6: warning: symbol 'iecm=
_rx_desc_rel_all' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:486:6: warning: symbol 'iecm=
_rx_hdr_buf_hw_alloc' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:564:47: warning: incorrect t=
ype in assignment (different base types)
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:564:47:    expected restrict=
ed __le16 [usertype] buf_id
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:564:47:    got restricted __=
le64 [usertype]
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:2072:50: warning: Using plai=
n integer as NULL pointer
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:2319:27: warning: cast to re=
stricted __le32
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:2319:27: warning: cast from =
restricted __le16
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:2852:23: warning: cast to re=
stricted __le16
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3086:17: warning: incorrect =
type in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3086:17:    expected void vo=
latile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3086:17:    got unsigned cha=
r [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3414:9: warning: incorrect t=
ype in argument 2 (different address spaces)
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3414:9:    expected void vol=
atile [noderef] <asn:2> *addr
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3414:9:    got unsigned char=
 [usertype] *
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3565:5: warning: symbol 'iec=
m_vport_splitq_napi_poll' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3603:6: warning: symbol 'iec=
m_vport_intr_map_vector_to_qs' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3715:5: warning: symbol 'iec=
m_vport_intr_alloc' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:1702:34: warning: incorrect =
type in assignment (different base types)
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:1702:34:    expected unsigne=
d char [usertype] cmd_dtype
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:1702:34:    got restricted _=
_le16 [usertype]
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:12:6: warning: symbol 'i=
ecm_recv_event_msg' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:61:1: warning: symbol 'i=
ecm_mb_clean' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_main.c:17:5: warning: symbol 'debug=
' was not declared. Should it be static?
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:144: warning: Function p=
arameter or member 'qinfo' not described in 'iecm_ctlq_add'
../drivers/net/ethernet/intel/iecm/iecm_controlq.c:144: warning: Excess fun=
ction parameter 'q_info' description in 'iecm_ctlq_add'
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_osdep.c:5:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.=
c:5:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c:584: warning: Functi=
on parameter or member 'rx_desc' not described in 'iecm_rx_singleq_process_=
skb_fields'
../drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c:584: warning: Functi=
on parameter or member 'ptype' not described in 'iecm_rx_singleq_process_sk=
b_fields'
../drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c:645: warning: bad li=
ne:=20
../drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c:689: warning: Functi=
on parameter or member 'dev' not described in 'iecm_singleq_rx_get_buf_page'
../drivers/net/ethernet/intel/iecm/iecm_lib.c:49:13: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_mb_intr_clean=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
   49 | irqreturn_t iecm_mb_intr_clean(int __always_unused irq, void *data)
      |             ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:63:6: warning: no previous pr=
ototype for =C3=A2=E2=82=AC=CB=9Ciecm_mb_irq_enable=C3=A2=E2=82=AC=E2=84=A2=
 [-Wmissing-prototypes]
   63 | void iecm_mb_irq_enable(struct iecm_adapter *adapter)
      |      ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:77:5: warning: no previous pr=
ototype for =C3=A2=E2=82=AC=CB=9Ciecm_mb_intr_req_irq=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
   77 | int iecm_mb_intr_req_irq(struct iecm_adapter *adapter)
      |     ^~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:104:6: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_get_mb_vec_id=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
  104 | void iecm_get_mb_vec_id(struct iecm_adapter *adapter)
      |      ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:122:5: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_mb_intr_init=C3=A2=E2=82=AC=E2=84=A2=
 [-Wmissing-prototypes]
  122 | int iecm_mb_intr_init(struct iecm_adapter *adapter)
      |     ^~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:140:6: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_intr_distribute=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
  140 | void iecm_intr_distribute(struct iecm_adapter *adapter)
      |      ^~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:417:5: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_vport_rel=C3=A2=E2=82=AC=E2=84=A2 [-=
Wmissing-prototypes]
  417 | int iecm_vport_rel(struct iecm_vport *vport)
      |     ^~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:748:6: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_deinit_task=C3=A2=E2=82=AC=E2=84=A2 =
[-Wmissing-prototypes]
  748 | void iecm_deinit_task(struct iecm_adapter *adapter)
      |      ^~~~~~~~~~~~~~~~
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_lib.c:6:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_ethtool.c:4:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_lib.c:490: warning: Function parame=
ter or member 'vport_id' not described in 'iecm_vport_alloc'
../drivers/net/ethernet/intel/iecm/iecm_lib.c:490: warning: Excess function=
 parameter 'vport_type' description in 'iecm_vport_alloc'
../drivers/net/ethernet/intel/iecm/iecm_ethtool.c:80: warning: Function par=
ameter or member 'abs_rx_qid' not described in 'iecm_find_virtual_qid'
../drivers/net/ethernet/intel/iecm/iecm_ethtool.c:1031: warning: Function p=
arameter or member 'cmd' not described in 'iecm_get_link_ksettings'
../drivers/net/ethernet/intel/iecm/iecm_ethtool.c:1031: warning: Excess fun=
ction parameter 'ecmd' description in 'iecm_get_link_ksettings'
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_main.c:6:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:12:6: warning: no previo=
us prototype for =C3=A2=E2=82=AC=CB=9Ciecm_recv_event_msg=C3=A2=E2=82=AC=E2=
=84=A2 [-Wmissing-prototypes]
   12 | void iecm_recv_event_msg(struct iecm_vport *vport)
      |      ^~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:61:1: warning: no previo=
us prototype for =C3=A2=E2=82=AC=CB=9Ciecm_mb_clean=C3=A2=E2=82=AC=E2=84=A2=
 [-Wmissing-prototypes]
   61 | iecm_mb_clean(struct iecm_adapter *adapter)
      | ^~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:1422: warning: Function =
parameter or member 'vport' not described in 'iecm_send_get_stats_msg'
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:1422: warning: Excess fu=
nction parameter 'adapter' description in 'iecm_send_get_stats_msg'
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:1701: warning: Function =
parameter or member 'hw' not described in 'iecm_find_ctlq'
../drivers/net/ethernet/intel/iecm/iecm_virtchnl.c:1701: warning: Excess fu=
nction parameter 'adapter' description in 'iecm_find_ctlq'
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:84:6: warning: no previous p=
rototype for =C3=A2=E2=82=AC=CB=9Ciecm_tx_buf_rel_all=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
   84 | void iecm_tx_buf_rel_all(struct iecm_queue *txq)
      |      ^~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:115:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_tx_desc_rel=C3=A2=E2=82=AC=E2=84=A2=
 [-Wmissing-prototypes]
  115 | void iecm_tx_desc_rel(struct iecm_queue *txq, bool bufq)
      |      ^~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:136:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_tx_desc_rel_all=C3=A2=E2=82=AC=E2=
=84=A2 [-Wmissing-prototypes]
  136 | void iecm_tx_desc_rel_all(struct iecm_vport *vport)
      |      ^~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:312:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_rx_buf_rel_all=C3=A2=E2=82=AC=E2=84=
=A2 [-Wmissing-prototypes]
  312 | void iecm_rx_buf_rel_all(struct iecm_queue *rxq)
      |      ^~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:341:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_rx_desc_rel=C3=A2=E2=82=AC=E2=84=A2=
 [-Wmissing-prototypes]
  341 | void iecm_rx_desc_rel(struct iecm_queue *rxq, bool bufq,
      |      ^~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:371:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_rx_desc_rel_all=C3=A2=E2=82=AC=E2=
=84=A2 [-Wmissing-prototypes]
  371 | void iecm_rx_desc_rel_all(struct iecm_vport *vport)
      |      ^~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:486:6: warning: no previous =
prototype for =C3=A2=E2=82=AC=CB=9Ciecm_rx_hdr_buf_hw_alloc=C3=A2=E2=82=AC=
=E2=84=A2 [-Wmissing-prototypes]
  486 | bool iecm_rx_hdr_buf_hw_alloc(struct iecm_queue *rxq,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3565:5: warning: no previous=
 prototype for =C3=A2=E2=82=AC=CB=9Ciecm_vport_splitq_napi_poll=C3=A2=E2=82=
=AC=E2=84=A2 [-Wmissing-prototypes]
 3565 | int iecm_vport_splitq_napi_poll(struct napi_struct *napi, int budge=
t)
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3603:6: warning: no previous=
 prototype for =C3=A2=E2=82=AC=CB=9Ciecm_vport_intr_map_vector_to_qs=C3=A2=
=E2=82=AC=E2=84=A2 [-Wmissing-prototypes]
 3603 | void iecm_vport_intr_map_vector_to_qs(struct iecm_vport *vport)
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3715:5: warning: no previous=
 prototype for =C3=A2=E2=82=AC=CB=9Ciecm_vport_intr_alloc=C3=A2=E2=82=AC=E2=
=84=A2 [-Wmissing-prototypes]
 3715 | int iecm_vport_intr_alloc(struct iecm_vport *vport)
      |     ^~~~~~~~~~~~~~~~~~~~~
In file included from ../include/linux/net/intel/iecm.h:50,
                 from ../drivers/net/ethernet/intel/iecm/iecm_txrx.c:4:
../include/linux/net/intel/iecm_txrx.h:293:30: warning: =C3=A2=E2=82=AC=CB=
=9Ciecm_rx_ptype_lkup=C3=A2=E2=82=AC=E2=84=A2 defined but not used [-Wunuse=
d-const-variable=3D]
  293 | struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE]=
 =3D {
      |                              ^~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:2593: warning: Function para=
meter or member 'dev' not described in 'iecm_rx_get_buf_page'
../drivers/net/ethernet/intel/iecm/iecm_txrx.c:3841: warning: Function para=
meter or member 'qid_list' not described in 'iecm_get_rx_qid_list'
