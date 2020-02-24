Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2A16A2C8
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgBXJlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:41:19 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33266 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726673AbgBXJlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 04:41:19 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 355AC68006F;
        Mon, 24 Feb 2020 09:41:16 +0000 (UTC)
Received: from ukex01.SolarFlarecom.com (10.17.10.4) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 24 Feb 2020 09:41:11 +0000
Received: from ukex01.SolarFlarecom.com ([fe80::2568:4ef2:2513:7e2a]) by
 ukex01.SolarFlarecom.com ([fe80::2568:4ef2:2513:7e2a%14]) with mapi id
 15.00.1395.000; Mon, 24 Feb 2020 09:41:11 +0000
Content-Type: multipart/mixed;
        boundary="_000_158253727068835761solarflarecom_"
From:   Tom Zhao <tzhao@solarflare.com>
To:     kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        David Miller <davem@davemloft.net>,
        Net Dev <netdev@vger.kernel.org>,
        linux-net-drivers <linux-net-drivers@solarflare.com>
Subject: Re: [PATCH net-next] sfc: complete the next packet when we receive a
 timestamp
Thread-Topic: [PATCH net-next] sfc: complete the next packet when we receive a
 timestamp
Thread-Index: AQHV5y4ZRIfhQJt6SEGt6Q3ZYbYgc6gnO7qAgALi5WE=
Date:   Mon, 24 Feb 2020 09:41:10 +0000
Message-ID: <1582537270688.35761@solarflare.com>
References: <f84701f1-f54c-68fa-ef20-ccaabbf3beaf@solarflare.com>,<202002222146.hHWMuzDx%lkp@intel.com>
In-Reply-To: <202002222146.hHWMuzDx%lkp@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <1582537270688.35761@solarflare.com>
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [193.34.186.16]
x-tm-as-product-ver: SMEX-12.5.0.1300-8.5.1020-25250.003
x-tm-as-result: No-17.499000-8.000000-10
x-tmase-matchedrid: DuKherWvI/vuo96mfIBuopzEHTUOuMX33dCmvEa6IiGoLZarzrrPmdUc
        WYCb/v9or5ezCpT0hyTOMm2PsqmZkzdU4n9N9PJicTela9PpnnzRjnAHxymurhBVEcLcHoVgPo+
        GPoN9kIRhHCnaiE65lET1c90o0knrMz0EFG5lnW+W0Geml8+YulFH/t3Gql8CmbdPE3zcujhfdO
        GeiKObmET/ZwE8KxLubG0Px+WXp+wzJ/OGKCQFVEmSRRbSc9s3+KgiyLtJrSD7+53TnNrjJB3+O
        LpZQttdVaIdEZADYEJNbr25m6eaMz5tuuiy1//6i82UiskMqcypXdWa4gU0S1bDmwy31ULE5TL6
        apB3DsovPUZhEG3lqMnXGdBEfBnRedTACv7eJKJ2GcWKGZufBX/uJVNe10xV33Nl3elSfsqf8qm
        NmRlHgFgEm4VwYZaef1scSIHokx7+PzzbebkcBG1rAlJKwOBJQt4kQKXEUArLkl8e9W70i6lay3
        WTTYkV0w3x8XAu7LKx/P8JGgaRQjEMBympXzDhh2VzUlo4HVN9dEBz6zdEV49EckptbmSOQPUnS
        IMN7Vt2kaxOr+iuYlpkRa/65C/tdohsSPGTO+EWGaCgD30OglBijjE0XjY+bjk25GcDBTxfLzzY
        QSB3CMRY72YZeVvqn7XN8zPoZ6QrHbHQd211AV0M0m7kLZXYZG3SCLP7QtKbKItl61J/ybLn+0V
        m71LcOAawE8JvIaLfd+P6wwCt81HNfjtV/QMx
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-tmase-result: 10--17.499000-8.000000
x-tmase-version: SMEX-12.5.0.1300-8.5.1020-25250.003
MIME-Version: 1.0
X-MDID: 1582537277-Vkd2mDH84Q35
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_000_158253727068835761solarflarecom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi David,=0A=
=0A=
Sorry I think I applied this to a stale repo. I will respin this when I get=
 time.=0A=
________________________________________=0A=
From: kbuild test robot <lkp@intel.com>=0A=
Sent: 22 February 2020 13:36=0A=
To: Tom Zhao=0A=
Cc: kbuild-all@lists.01.org; David Miller; Net Dev; linux-net-drivers=0A=
Subject: Re: [PATCH net-next] sfc: complete the next packet when we receive=
 a timestamp=0A=
=0A=
Hi Tom,=0A=
=0A=
Thank you for the patch! Yet something to improve:=0A=
=0A=
[auto build test ERROR on v5.5]=0A=
[cannot apply to net-next/master linus/master sparc-next/master ipvs/master=
 v5.6-rc2 v5.6-rc1 next-20200221]=0A=
[if your patch is applied to the wrong git tree, please drop us a note to h=
elp=0A=
improve the system. BTW, we also suggest to use '--base' option to specify =
the=0A=
base tree in git format-patch, please see https://stackoverflow.com/a/37406=
982]=0A=
=0A=
url:    https://github.com/0day-ci/linux/commits/Tom-Zhao/sfc-complete-the-=
next-packet-when-we-receive-a-timestamp/20200221-083821=0A=
base:    d5226fa6dbae0569ee43ecfc08bdcd6770fc4755=0A=
config: arm64-allyesconfig (attached as .config)=0A=
compiler: aarch64-linux-gcc (GCC) 7.5.0=0A=
reproduce:=0A=
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/=
make.cross -O ~/bin/make.cross=0A=
        chmod +x ~/bin/make.cross=0A=
        # save the attached .config to linux build tree=0A=
        GCC_VERSION=3D7.5.0 make.cross ARCH=3Darm64=0A=
=0A=
If you fix the issue, kindly add following tag=0A=
Reported-by: kbuild test robot <lkp@intel.com>=0A=
=0A=
All errors (new ones prefixed by >>):=0A=
=0A=
   drivers/net/ethernet/sfc/tx.c: In function 'efx_xmit_done_check_empty':=
=0A=
>> drivers/net/ethernet/sfc/tx.c:845:31: error: implicit declaration of fun=
ction 'ACCESS_ONCE'; did you mean 'READ_ONCE'? [-Werror=3Dimplicit-function=
-declaration]=0A=
      tx_queue->old_write_count =3D ACCESS_ONCE(tx_queue->write_count);=0A=
                                  ^~~~~~~~~~~=0A=
                                  READ_ONCE=0A=
   drivers/net/ethernet/sfc/tx.c: In function 'efx_xmit_done_single':=0A=
>> drivers/net/ethernet/sfc/tx.c:905:19: error: 'struct efx_nic' has no mem=
ber named 'errors'=0A=
       atomic_inc(&efx->errors.spurious_tx);=0A=
                      ^~=0A=
   cc1: some warnings being treated as errors=0A=
=0A=
vim +845 drivers/net/ethernet/sfc/tx.c=0A=
=0A=
   841=0A=
   842  static void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue=
)=0A=
   843  {=0A=
   844          if ((int)(tx_queue->read_count - tx_queue->old_write_count)=
 >=3D 0) {=0A=
 > 845                  tx_queue->old_write_count =3D ACCESS_ONCE(tx_queue-=
>write_count);=0A=
   846                  if (tx_queue->read_count =3D=3D tx_queue->old_write=
_count) {=0A=
   847                          smp_mb();=0A=
   848                          tx_queue->empty_read_count =3D=0A=
   849                                  tx_queue->read_count | EFX_EMPTY_CO=
UNT_VALID;=0A=
   850                  }=0A=
   851          }=0A=
   852  }=0A=
   853=0A=
   854  void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int inde=
x)=0A=
   855  {=0A=
   856          unsigned fill_level;=0A=
   857          struct efx_nic *efx =3D tx_queue->efx;=0A=
   858          struct efx_tx_queue *txq2;=0A=
   859          unsigned int pkts_compl =3D 0, bytes_compl =3D 0;=0A=
   860=0A=
   861          EFX_WARN_ON_ONCE_PARANOID(index > tx_queue->ptr_mask);=0A=
   862=0A=
   863          efx_dequeue_buffers(tx_queue, index, &pkts_compl, &bytes_co=
mpl);=0A=
   864          tx_queue->pkts_compl +=3D pkts_compl;=0A=
   865          tx_queue->bytes_compl +=3D bytes_compl;=0A=
   866=0A=
   867          if (pkts_compl > 1)=0A=
   868                  ++tx_queue->merge_events;=0A=
   869=0A=
   870          /* See if we need to restart the netif queue.  This memory=
=0A=
   871           * barrier ensures that we write read_count (inside=0A=
   872           * efx_dequeue_buffers()) before reading the queue status.=
=0A=
   873           */=0A=
   874          smp_mb();=0A=
   875          if (unlikely(netif_tx_queue_stopped(tx_queue->core_txq)) &&=
=0A=
   876              likely(efx->port_enabled) &&=0A=
   877              likely(netif_device_present(efx->net_dev))) {=0A=
   878                  txq2 =3D efx_tx_queue_partner(tx_queue);=0A=
   879                  fill_level =3D max(tx_queue->insert_count - tx_queu=
e->read_count,=0A=
   880                                   txq2->insert_count - txq2->read_co=
unt);=0A=
   881                  if (fill_level <=3D efx->txq_wake_thresh)=0A=
   882                          netif_tx_wake_queue(tx_queue->core_txq);=0A=
   883          }=0A=
   884=0A=
   885          efx_xmit_done_check_empty(tx_queue);=0A=
   886  }=0A=
   887=0A=
   888  void efx_xmit_done_single(struct efx_tx_queue *tx_queue)=0A=
   889  {=0A=
   890          unsigned int pkts_compl =3D 0, bytes_compl =3D 0;=0A=
   891          unsigned int read_ptr;=0A=
   892          bool finished =3D false;=0A=
   893=0A=
   894          read_ptr =3D tx_queue->read_count & tx_queue->ptr_mask;=0A=
   895=0A=
   896          while (!finished) {=0A=
   897                  struct efx_tx_buffer *buffer =3D &tx_queue->buffer[=
read_ptr];=0A=
   898=0A=
   899                  if (!efx_tx_buffer_in_use(buffer)) {=0A=
   900                          struct efx_nic *efx =3D tx_queue->efx;=0A=
   901=0A=
   902                          netif_err(efx, hw, efx->net_dev,=0A=
   903                                    "TX queue %d spurious single TX c=
ompletion\n",=0A=
   904                                    tx_queue->queue);=0A=
 > 905                          atomic_inc(&efx->errors.spurious_tx);=0A=
   906                          efx_schedule_reset(efx, RESET_TYPE_TX_SKIP)=
;=0A=
   907                          return;=0A=
   908                  }=0A=
   909=0A=
   910                  /* Need to check the flag before dequeueing. */=0A=
   911                  if (buffer->flags & EFX_TX_BUF_SKB)=0A=
   912                          finished =3D true;=0A=
   913                  efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &=
bytes_compl);=0A=
   914=0A=
   915                  ++tx_queue->read_count;=0A=
   916                  read_ptr =3D tx_queue->read_count & tx_queue->ptr_m=
ask;=0A=
   917          }=0A=
   918=0A=
   919          tx_queue->pkts_compl +=3D pkts_compl;=0A=
   920          tx_queue->bytes_compl +=3D bytes_compl;=0A=
   921=0A=
   922          EFX_WARN_ON_PARANOID(pkts_compl !=3D 1);=0A=
   923=0A=
   924          efx_xmit_done_check_empty(tx_queue);=0A=
   925  }=0A=
   926=0A=
=0A=
---=0A=
0-DAY CI Kernel Test Service, Intel Corporation=0A=
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org=0A=

--_000_158253727068835761solarflarecom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AGYAYwA6ACAAYwBvAG0AcABsAGUAdABlACAAdABoAGUAIABuAGUAeAB0ACAAcABhAGMAawBlAHQA
IAB3AGgAZQBuACAAdwBlACAAcgBlAGMAZQBpAHYAZQAgAGEAIAB0AGkAbQBlAHMAdABhAG0AcAAA
AAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfANk/AQAAAAACAABIAGkAIABEAGEA
dgBpAGQALAAKAAoAUwBvAHIAcgB5ACAASQAgAHQAaABpAG4AawAgAEkAIABhAHAAcABsAGkAZQBk
ACAAdABoAGkAcwAgAHQAbwAgAGEAIABzAHQAYQBsAGUAIAByAGUAcABvAC4AIABJACAAdwBpAGwA
bAAgAHIAZQBzAHAAaQBuACAAdABoAGkAcwAgAHcAaABlAG4AIABJACAAZwBlAHQAIAB0AGkAbQBl
AC4ACgBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8A
XwBfAF8AXwBfAF8AXwBfAF8AXwBfAF8AXwBfAAoARgByAG8AbQA6ACAAawBiAHUAaQBsAGQAIAB0
AGUAcwB0ACAAcgBvAGIAbwB0ACAAPABsAGsAcABAAGkAbgB0AGUAbAAuAGMAbwBtAD4ACgBTAGUA
bgB0ADoAIAAyADIAIABGAGUAYgByAHUAYQByAHkAIAAyADAAMgAwACAAMQAzADoAMwA2AAoAVABv
ADoAIABUAG8AbQAgAFoAaABhAG8ACgBDAGMAOgAgAGsAYgB1AGkAbABkAC0AYQBsAGwAQABsAGkA
cwB0AHMALgAwADEALgBvAHIAZwA7ACAARABhAHYAaQBkACAATQBpAGwAbAAAAAMALgAAAAAAHwBC
EAEAAABMAAAAPAAyADAAMgAwADAAMgAyADIAMgAxADQANgAuAGgASABXAE0AdQB6AEQAeAAlAGwA
awBwAEAAaQBuAHQAZQBsAC4AYwBvAG0APgAAAAIBcQABAAAAIAAAAAEB1ecuGUSH4UCbekhBrekN
2WG2IHOoJzu6gIAC4uVhHwBwAAEAAACWAAAAWwBQAEEAVABDAEgAIABuAGUAdAAtAG4AZQB4AHQA
XQAgAHMAZgBjADoAIABjAG8AbQBwAGwAZQB0AGUAIAB0AGgAZQAgAG4AZQB4AHQAIABwAGEAYwBr
AGUAdAAgAHcAaABlAG4AIAB3AGUAIAByAGUAYwBlAGkAdgBlACAAYQAgAHQAaQBtAGUAcwB0AGEA
bQBwAAAAAAAfADUQAQAAAEoAAAA8ADEANQA4ADIANQAzADcAMgA3ADAANgA4ADgALgAzADUANwA2
ADEAQABzAG8AbABhAHIAZgBsAGEAcgBlAC4AYwBvAG0APgAAAAAAHwA5EAEAAAC4AAAAPABmADgA
NAA3ADAAMQBmADEALQBmADUANABjAC0ANgA4AGYAYQAtAGUAZgAyADAALQBjAGMAYQBhAGIAYgBm
ADMAYgBlAGEAZgBAAHMAbwBsAGEAcgBmAGwAYQByAGUALgBjAG8AbQA+ACwAPAAyADAAMgAwADAA
MgAyADIAMgAxADQANgAuAGgASABXAE0AdQB6AEQAeAAlAGwAawBwAEAAaQBuAHQAZQBsAC4AYwBv
AG0APgAAAAMA3j+vbwAAQAAHMIAhw3326tUBAwAmAAAAAAALAAYMAAAAAAIBEzABAAAAEAAAAESH
4UCbekhBrekN2WG2IHMCARQwAQAAAAwAAADrAQAAt78kuEgAAAAfAPg/AQAAABIAAABUAG8AbQAg
AFoAaABhAG8AAAAAAB8AIkABAAAABgAAAEUAWAAAAAAAHwAjQAEAAAD4AAAALwBPAD0AUwBPAEwA
QQBSAEYATABBAFIARQAvAE8AVQA9AEUAWABDAEgAQQBOAEcARQAgAEEARABNAEkATgBJAFMAVABS
AEEAVABJAFYARQAgAEcAUgBPAFUAUAAgACgARgBZAEQASQBCAE8ASABGADIAMwBTAFAARABMAFQA
KQAvAEMATgA9AFIARQBDAEkAUABJAEUATgBUAFMALwBDAE4APQBGADQARAAyAEMANwAxADIARgBE
AEIAMAA0AEEANgBBADgARQBGADEARQBEADgAMwAyAEQAMwAxAEIAMAAwADAALQBUAE8ATQAgAFoA
SABBAE8AAAAfACRAAQAAAAYAAABFAFgAAAAAAB8AJUABAAAA+AAAAC8ATwA9AFMATwBMAEEAUgBG
AEwAQQBSAEUALwBPAFUAPQBFAFgAQwBIAEEATgBHAEUAIABBAEQATQBJAE4ASQBTAFQAUgBBAFQA
SQBWAEUAIABHAFIATwBVAFAAIAAoAEYAWQBEAEkAQgBPAEgARgAyADMAUwBQAEQATABUACkALwBD
AE4APQBSAEUAQwBJAFAASQBFAE4AVABTAC8AQwBOAD0ARgA0AEQAMgBDADcAMQAyAEYARABCADAA
NABBADYAQQA4AEUARgAxAEUARAA4ADMAMgBEADMAMQBCADAAMAAwAC0AVABPAE0AIABaAEgAQQBP
AAAAHwAwQAEAAAASAAAAVABvAG0AIABaAGgAYQBvAAAAAAAfADFAAQAAABIAAABUAG8AbQAgAFoA
aABhAG8AAAAAAB8AOEABAAAAEgAAAFQAbwBtACAAWgBoAGEAbwAAAAAAHwA5QAEAAAASAAAAVABv
AG0AIABaAGgAYQBvAAAAAAADAFlAAAAAAAMAWkAAAAAAAwAAgAiWIyNdaDJHnFVMlctOjjMBAAAA
LgAAAEwAYQB0AGUAcwB0AE0AZQBzAHMAYQBnAGUAVwBvAHIAZABDAG8AdQBuAHQAAAAAABQAAAAD
AA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQA
dABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAFIAAAB4AC0AbQBz
AC0AZQB4AGMAaABhAG4AZwBlAC0AdAByAGEAbgBzAHAAbwByAHQALQBmAHIAbwBtAGUAbgB0AGkA
dAB5AGgAZQBhAGQAZQByAAAAAAABAAAADgAAAEgAbwBzAHQAZQBkAAAAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAACAA
AABbADEAOQAzAC4AMwA0AC4AMQA4ADYALgAxADYAXQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAA
ACgAAAB4AC0AdABtAC0AYQBzAC0AcAByAG8AZAB1AGMAdAAtAHYAZQByAAAAAQAAAEgAAABTAE0A
RQBYAC0AMQAyAC4ANQAuADAALgAxADMAMAAwAC0AOAAuADUALgAxADAAMgAwAC0AMgA1ADIANQAw
AC4AMAAwADMAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAeAAtAHQAbQAtAGEAcwAtAHIA
ZQBzAHUAbAB0AAAAAAABAAAAMgAAAE4AbwAtADEANwAuADQAOQA5ADAAMAAwAC0AOAAuADAAMAAw
ADAAMAAwAC0AMQAwAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAmAAAAeAAtAHQAbQBhAHMA
ZQAtAG0AYQB0AGMAaABlAGQAcgBpAGQAAAAAAAEAAAAWBgAARAB1AEsAaABlAHIAVwB2AEkALwB2
AHUAbwA5ADYAbQBmAEkAQgB1AG8AcAB6AEUASABUAFUATwB1AE0AWAAzADMAZABDAG0AdgBFAGEA
NgBJAGkARwBvAEwAWgBhAHIAegByAHIAUABtAGQAVQBjAAkAVwBZAEMAYgAvAHYAOQBvAHIANQBl
AHoAQwBwAFQAMABoAHkAVABPAE0AbQAyAFAAcwBxAG0AWgBrAHoAZABVADQAbgA5AE4AOQBQAEoA
aQBjAFQAZQBsAGEAOQBQAHAAbgBuAHoAUgBqAG4AQQBIAHgAeQBtAHUAcgBoAEIAVgBFAGMATABj
AEgAbwBWAGcAUABvACsACQBHAFAAbwBOADkAawBJAFIAaABIAEMAbgBhAGkARQA2ADUAbABFAFQA
MQBjADkAMABvADAAawBuAHIATQB6ADAARQBGAEcANQBsAG4AVwArAFcAMABHAGUAbQBsADgAKwBZ
AHUAbABGAEgALwB0ADMARwBxAGwAOABDAG0AYgBkAFAARQAzAHoAYwB1AGoAaABmAGQATwAJAEcA
ZQBpAEsATwBiAG0ARQBUAC8AWgB3AEUAOABLAHgATAB1AGIARwAwAFAAeAArAFcAWABwACsAdwB6
AEoALwBPAEcASwBDAFEARgBWAEUAbQBTAFIAUgBiAFMAYwA5AHMAMwArAEsAZwBpAHkATAB0AEoA
cgBTAEQANwArADUAMwBUAG4ATgByAGoASgBCADMAKwBPAAkATABwAFoAUQB0AHQAZABWAGEASQBk
AEUAWgBBAEQAWQBFAEoATgBiAHIAMgA1AG0ANgBlAGEATQB6ADUAdAB1AHUAaQB5ADEALwAvADYA
aQA4ADIAVQBpAHMAawBNAHEAYwB5AHAAWABkAFcAYQA0AGcAVQAwAFMAMQBiAEQAbQB3AHkAMwAx
AFUATABFADUAVABMADYACQBhAHAAQgAzAEQAcwBvAHYAUABVAFoAaABFAEcAMwBsAHEATQBuAFgA
RwBkAEIARQBmAEIAbgBSAGUAZABUAEEAQwB2ADcAZQBKAEsASgAyAEcAYwBXAEsARwBaAHUAZgBC
AFgALwB1AEoAVgBOAGUAMQAwAHgAVgAzADMATgBsADMAZQBsAFMAZgBzAHEAZgA4AHEAbQAJAE4A
bQBSAGwASABnAEYAZwBFAG0ANABWAHcAWQBaAGEAZQBmADEAcwBjAFMASQBIAG8AawB4ADcAKwBQ
AHoAegBiAGUAYgBrAGMAQgBHADEAcgBBAGwASgBLAHcATwBCAEoAUQB0ADQAawBRAEsAWABFAFUA
QQByAEwAawBsADgAZQA5AFcANwAwAGkANgBsAGEAeQAzAAkAVwBUAFQAWQBrAFYAMAB3ADMAeAA4
AFgAQQB1ADcATABLAHgALwBQADgASgBHAGcAYQBSAFEAagBFAE0AQgB5AG0AcABYAHoARABoAGgA
MgBWAHoAVQBsAG8ANABIAFYATgA5AGQARQBCAHoANgB6AGQARQBWADQAOQBFAGMAawBwAHQAYgBt
AFMATwBRAFAAVQBuAFMACQBJAE0ATgA3AFYAdAAyAGsAYQB4AE8AcgArAGkAdQBZAGwAcABrAFIA
YQAvADYANQBDAC8AdABkAG8AaABzAFMAUABHAFQATwArAEUAVwBHAGEAQwBnAEQAMwAwAE8AZwBs
AEIAaQBqAGoARQAwAFgAagBZACsAYgBqAGsAMgA1AEcAYwBEAEIAVAB4AGYATAB6AHoAWQAJAFEA
UwBCADMAQwBNAFIAWQA3ADIAWQBaAGUAVgB2AHEAbgA3AFgATgA4AHoAUABvAFoANgBRAHIASABi
AEgAUQBkADIAMQAxAEEAVgAwAE0AMABtADcAawBMAFoAWABZAFoARwAzAFMAQwBMAFAANwBRAHQA
SwBiAEsASQB0AGwANgAxAEoALwB5AGIATABuACsAMABWAAkAbQA3ADEATABjAE8AQQBhAHcARQA4
AEoAdgBJAGEATABmAGQAKwBQADYAdwB3AEMAdAA4ADEASABOAGYAagB0AFYALwBRAE0AeAAAAAAA
HwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAOgAAAHgALQB0AG0ALQBhAHMALQB1AHMAZQByAC0AYQBw
AHAAcgBvAHYAZQBkAC0AcwBlAG4AZABlAHIAAAAAAAEAAAAIAAAAWQBlAHMAAAAfAACAhgMCAAAA
AADAAAAAAAAARgEAAAA4AAAAeAAtAHQAbQAtAGEAcwAtAHUAcwBlAHIALQBiAGwAbwBjAGsAZQBk
AC0AcwBlAG4AZABlAHIAAAABAAAABgAAAE4AbwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAA
HgAAAHgALQB0AG0AYQBzAGUALQByAGUAcwB1AGwAdAAAAAAAAQAAAC4AAAAxADAALQAtADEANwAu
ADQAOQA5ADAAMAAwAC0AOAAuADAAMAAwADAAMAAwAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEA
AAAgAAAAeAAtAHQAbQBhAHMAZQAtAHYAZQByAHMAaQBvAG4AAAABAAAASAAAAFMATQBFAFgALQAx
ADIALgA1AC4AMAAuADEAMwAwADAALQA4AC4ANQAuADEAMAAyADAALQAyADUAMgA1ADAALgAwADAA
MwAAAJ+m

--_000_158253727068835761solarflarecom_--
