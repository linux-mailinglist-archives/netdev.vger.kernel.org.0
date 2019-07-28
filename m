Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1557477D9E
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 06:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfG1EHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 00:07:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:62290 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfG1EHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 00:07:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jul 2019 21:07:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,317,1559545200"; 
   d="scan'208";a="346262795"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Jul 2019 21:07:13 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hraSm-000Bog-Nn; Sun, 28 Jul 2019 12:07:12 +0800
Date:   Sun, 28 Jul 2019 12:06:14 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     kbuild-all@01.org, mikelley@microsoft.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        davem@davemloft.net, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himadri Pandya <himadri18.07@gmail.com>
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
Message-ID: <201907281257.gVlvGWLv%lkp@intel.com>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725051125.10605-1-himadri18.07@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Himadri,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3-rc1 next-20190726]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Himadri-Pandya/hv_sock-use-HV_HYP_PAGE_SIZE-instead-of-PAGE_SIZE_4K/20190726-085229
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   include/linux/sched.h:609:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:609:73: sparse: sparse: invalid named zero-width bitfield `value'
   include/linux/sched.h:610:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:610:67: sparse: sparse: invalid named zero-width bitfield `bucket_id'
   net/vmw_vsock/hyperv_transport.c:214:39: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:214:39: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse: sparse: incompatible types for operation (-)
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse:    left side has type bad type
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse:    right side has type int
   net/vmw_vsock/hyperv_transport.c:214:39: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse: sparse: incompatible types for operation (-)
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse:    left side has type bad type
>> net/vmw_vsock/hyperv_transport.c:214:39: sparse:    right side has type int
   net/vmw_vsock/hyperv_transport.c:65:17: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:65:17: sparse: sparse: bad constant expression type
   net/vmw_vsock/hyperv_transport.c:387:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:388:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
>> net/vmw_vsock/hyperv_transport.c:390:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:391:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:392:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:392:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:392:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:392:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:393:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:394:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:395:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:395:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:395:26: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:395:26: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:465:25: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:466:25: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:666:9: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: cast from unknown type
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: undefined identifier 'HV_HYP_PAGE_SIZE'
   net/vmw_vsock/hyperv_transport.c:681:28: sparse: sparse: cast from unknown type

vim +214 net/vmw_vsock/hyperv_transport.c

ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   59  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   60  struct hvs_send_buf {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   61  	/* The header before the payload data */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   62  	struct vmpipe_proto_header hdr;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   63  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   64  	/* The payload */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  @65  	u8 data[HVS_SEND_BUF_SIZE];
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   66  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   67  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   68  #define HVS_HEADER_LEN	(sizeof(struct vmpacket_descriptor) + \
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   69  			 sizeof(struct vmpipe_proto_header))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   70  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   71  /* See 'prev_indices' in hv_ringbuffer_read(), hv_ringbuffer_write(), and
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   72   * __hv_pkt_iter_next().
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   73   */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   74  #define VMBUS_PKT_TRAILER_SIZE	(sizeof(u64))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   75  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   76  #define HVS_PKT_LEN(payload_len)	(HVS_HEADER_LEN + \
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   77  					 ALIGN((payload_len), 8) + \
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   78  					 VMBUS_PKT_TRAILER_SIZE)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   79  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   80  union hvs_service_id {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   81  	uuid_le	srv_id;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   82  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   83  	struct {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   84  		unsigned int svm_port;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   85  		unsigned char b[sizeof(uuid_le) - sizeof(unsigned int)];
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   86  	};
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   87  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   88  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   89  /* Per-socket state (accessed via vsk->trans) */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   90  struct hvsock {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   91  	struct vsock_sock *vsk;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   92  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   93  	uuid_le vm_srv_id;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   94  	uuid_le host_srv_id;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   95  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   96  	struct vmbus_channel *chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   97  	struct vmpacket_descriptor *recv_desc;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   98  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26   99  	/* The length of the payload not delivered to userland yet */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  100  	u32 recv_data_len;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  101  	/* The offset of the payload */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  102  	u32 recv_data_off;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  103  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  104  	/* Have we sent the zero-length packet (FIN)? */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  105  	bool fin_sent;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  106  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  107  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  108  /* In the VM, we support Hyper-V Sockets with AF_VSOCK, and the endpoint is
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  109   * <cid, port> (see struct sockaddr_vm). Note: cid is not really used here:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  110   * when we write apps to connect to the host, we can only use VMADDR_CID_ANY
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  111   * or VMADDR_CID_HOST (both are equivalent) as the remote cid, and when we
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  112   * write apps to bind() & listen() in the VM, we can only use VMADDR_CID_ANY
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  113   * as the local cid.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  114   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  115   * On the host, Hyper-V Sockets are supported by Winsock AF_HYPERV:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  116   * https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  117   * guide/make-integration-service, and the endpoint is <VmID, ServiceId> with
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  118   * the below sockaddr:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  119   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  120   * struct SOCKADDR_HV
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  121   * {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  122   *    ADDRESS_FAMILY Family;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  123   *    USHORT Reserved;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  124   *    GUID VmId;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  125   *    GUID ServiceId;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  126   * };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  127   * Note: VmID is not used by Linux VM and actually it isn't transmitted via
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  128   * VMBus, because here it's obvious the host and the VM can easily identify
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  129   * each other. Though the VmID is useful on the host, especially in the case
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  130   * of Windows container, Linux VM doesn't need it at all.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  131   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  132   * To make use of the AF_VSOCK infrastructure in Linux VM, we have to limit
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  133   * the available GUID space of SOCKADDR_HV so that we can create a mapping
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  134   * between AF_VSOCK port and SOCKADDR_HV Service GUID. The rule of writing
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  135   * Hyper-V Sockets apps on the host and in Linux VM is:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  136   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  137   ****************************************************************************
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  138   * The only valid Service GUIDs, from the perspectives of both the host and *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  139   * Linux VM, that can be connected by the other end, must conform to this   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  140   * format: <port>-facb-11e6-bd58-64006a7986d3, and the "port" must be in    *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  141   * this range [0, 0x7FFFFFFF].                                              *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  142   ****************************************************************************
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  143   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  144   * When we write apps on the host to connect(), the GUID ServiceID is used.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  145   * When we write apps in Linux VM to connect(), we only need to specify the
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  146   * port and the driver will form the GUID and use that to request the host.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  147   *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  148   * From the perspective of Linux VM:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  149   * 1. the local ephemeral port (i.e. the local auto-bound port when we call
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  150   * connect() without explicit bind()) is generated by __vsock_bind_stream(),
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  151   * and the range is [1024, 0xFFFFFFFF).
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  152   * 2. the remote ephemeral port (i.e. the auto-generated remote port for
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  153   * a connect request initiated by the host's connect()) is generated by
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  154   * hvs_remote_addr_init() and the range is [0x80000000, 0xFFFFFFFF).
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  155   */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  156  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  157  #define MAX_LISTEN_PORT			((u32)0x7FFFFFFF)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  158  #define MAX_VM_LISTEN_PORT		MAX_LISTEN_PORT
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  159  #define MAX_HOST_LISTEN_PORT		MAX_LISTEN_PORT
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  160  #define MIN_HOST_EPHEMERAL_PORT		(MAX_HOST_LISTEN_PORT + 1)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  161  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  162  /* 00000000-facb-11e6-bd58-64006a7986d3 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  163  static const uuid_le srv_id_template =
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  164  	UUID_LE(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  165  		0x64, 0x00, 0x6a, 0x79, 0x86, 0xd3);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  166  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  167  static bool is_valid_srv_id(const uuid_le *id)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  168  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  169  	return !memcmp(&id->b[4], &srv_id_template.b[4], sizeof(uuid_le) - 4);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  170  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  171  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  172  static unsigned int get_port_by_srv_id(const uuid_le *svr_id)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  173  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  174  	return *((unsigned int *)svr_id);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  175  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  176  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  177  static void hvs_addr_init(struct sockaddr_vm *addr, const uuid_le *svr_id)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  178  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  179  	unsigned int port = get_port_by_srv_id(svr_id);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  180  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  181  	vsock_addr_init(addr, VMADDR_CID_ANY, port);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  182  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  183  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  184  static void hvs_remote_addr_init(struct sockaddr_vm *remote,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  185  				 struct sockaddr_vm *local)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  186  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  187  	static u32 host_ephemeral_port = MIN_HOST_EPHEMERAL_PORT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  188  	struct sock *sk;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  189  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  190  	vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  191  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  192  	while (1) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  193  		/* Wrap around ? */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  194  		if (host_ephemeral_port < MIN_HOST_EPHEMERAL_PORT ||
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  195  		    host_ephemeral_port == VMADDR_PORT_ANY)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  196  			host_ephemeral_port = MIN_HOST_EPHEMERAL_PORT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  197  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  198  		remote->svm_port = host_ephemeral_port++;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  199  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  200  		sk = vsock_find_connected_socket(remote, local);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  201  		if (!sk) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  202  			/* Found an available ephemeral port */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  203  			return;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  204  		}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  205  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  206  		/* Release refcnt got in vsock_find_connected_socket */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  207  		sock_put(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  208  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  209  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  210  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  211  static void hvs_set_channel_pending_send_size(struct vmbus_channel *chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  212  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  213  	set_channel_pending_send_size(chan,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26 @214  				      HVS_PKT_LEN(HVS_SEND_BUF_SIZE));
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  215  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  216  	virt_mb();
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  217  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  218  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  219  static bool hvs_channel_readable(struct vmbus_channel *chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  220  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  221  	u32 readable = hv_get_bytes_to_read(&chan->inbound);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  222  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  223  	/* 0-size payload means FIN */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  224  	return readable >= HVS_PKT_LEN(0);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  225  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  226  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  227  static int hvs_channel_readable_payload(struct vmbus_channel *chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  228  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  229  	u32 readable = hv_get_bytes_to_read(&chan->inbound);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  230  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  231  	if (readable > HVS_PKT_LEN(0)) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  232  		/* At least we have 1 byte to read. We don't need to return
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  233  		 * the exact readable bytes: see vsock_stream_recvmsg() ->
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  234  		 * vsock_stream_has_data().
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  235  		 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  236  		return 1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  237  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  238  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  239  	if (readable == HVS_PKT_LEN(0)) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  240  		/* 0-size payload means FIN */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  241  		return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  242  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  243  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  244  	/* No payload or FIN */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  245  	return -1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  246  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  247  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  248  static size_t hvs_channel_writable_bytes(struct vmbus_channel *chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  249  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  250  	u32 writeable = hv_get_bytes_to_write(&chan->outbound);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  251  	size_t ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  252  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  253  	/* The ringbuffer mustn't be 100% full, and we should reserve a
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  254  	 * zero-length-payload packet for the FIN: see hv_ringbuffer_write()
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  255  	 * and hvs_shutdown().
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  256  	 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  257  	if (writeable <= HVS_PKT_LEN(1) + HVS_PKT_LEN(0))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  258  		return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  259  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  260  	ret = writeable - HVS_PKT_LEN(1) - HVS_PKT_LEN(0);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  261  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  262  	return round_down(ret, 8);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  263  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  264  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  265  static int hvs_send_data(struct vmbus_channel *chan,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  266  			 struct hvs_send_buf *send_buf, size_t to_write)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  267  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  268  	send_buf->hdr.pkt_type = 1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  269  	send_buf->hdr.data_size = to_write;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  270  	return vmbus_sendpacket(chan, &send_buf->hdr,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  271  				sizeof(send_buf->hdr) + to_write,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  272  				0, VM_PKT_DATA_INBAND, 0);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  273  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  274  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  275  static void hvs_channel_cb(void *ctx)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  276  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  277  	struct sock *sk = (struct sock *)ctx;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  278  	struct vsock_sock *vsk = vsock_sk(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  279  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  280  	struct vmbus_channel *chan = hvs->chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  281  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  282  	if (hvs_channel_readable(chan))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  283  		sk->sk_data_ready(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  284  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  285  	if (hv_get_bytes_to_write(&chan->outbound) > 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  286  		sk->sk_write_space(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  287  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  288  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  289  static void hvs_do_close_lock_held(struct vsock_sock *vsk,
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  290  				   bool cancel_timeout)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  291  {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  292  	struct sock *sk = sk_vsock(vsk);
b4562ca7925a3be Dexuan Cui       2017-10-19  293  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  294  	sock_set_flag(sk, SOCK_DONE);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  295  	vsk->peer_shutdown = SHUTDOWN_MASK;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  296  	if (vsock_stream_has_data(vsk) <= 0)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  297  		sk->sk_state = TCP_CLOSING;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  298  	sk->sk_state_change(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  299  	if (vsk->close_work_scheduled &&
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  300  	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  301  		vsk->close_work_scheduled = false;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  302  		vsock_remove_sock(vsk);
b4562ca7925a3be Dexuan Cui       2017-10-19  303  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  304  		/* Release the reference taken while scheduling the timeout */
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  305  		sock_put(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  306  	}
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  307  }
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  308  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  309  static void hvs_close_connection(struct vmbus_channel *chan)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  310  {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  311  	struct sock *sk = get_per_channel_state(chan);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  312  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  313  	lock_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  314  	hvs_do_close_lock_held(vsock_sk(sk), true);
b4562ca7925a3be Dexuan Cui       2017-10-19  315  	release_sock(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  316  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  317  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  318  static void hvs_open_connection(struct vmbus_channel *chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  319  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  320  	uuid_le *if_instance, *if_type;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  321  	unsigned char conn_from_host;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  322  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  323  	struct sockaddr_vm addr;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  324  	struct sock *sk, *new = NULL;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  325  	struct vsock_sock *vnew = NULL;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  326  	struct hvsock *hvs = NULL;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  327  	struct hvsock *hvs_new = NULL;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  328  	int rcvbuf;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  329  	int ret;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  330  	int sndbuf;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  331  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  332  	if_type = &chan->offermsg.offer.if_type;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  333  	if_instance = &chan->offermsg.offer.if_instance;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  334  	conn_from_host = chan->offermsg.offer.u.pipe.user_def[0];
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  335  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  336  	/* The host or the VM should only listen on a port in
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  337  	 * [0, MAX_LISTEN_PORT]
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  338  	 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  339  	if (!is_valid_srv_id(if_type) ||
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  340  	    get_port_by_srv_id(if_type) > MAX_LISTEN_PORT)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  341  		return;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  342  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  343  	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  344  	sk = vsock_find_bound_socket(&addr);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  345  	if (!sk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  346  		return;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  347  
b4562ca7925a3be Dexuan Cui       2017-10-19  348  	lock_sock(sk);
3b4477d2dcf2709 Stefan Hajnoczi  2017-10-05  349  	if ((conn_from_host && sk->sk_state != TCP_LISTEN) ||
3b4477d2dcf2709 Stefan Hajnoczi  2017-10-05  350  	    (!conn_from_host && sk->sk_state != TCP_SYN_SENT))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  351  		goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  352  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  353  	if (conn_from_host) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  354  		if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  355  			goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  356  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  357  		new = __vsock_create(sock_net(sk), NULL, sk, GFP_KERNEL,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  358  				     sk->sk_type, 0);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  359  		if (!new)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  360  			goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  361  
3b4477d2dcf2709 Stefan Hajnoczi  2017-10-05  362  		new->sk_state = TCP_SYN_SENT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  363  		vnew = vsock_sk(new);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  364  		hvs_new = vnew->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  365  		hvs_new->chan = chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  366  	} else {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  367  		hvs = vsock_sk(sk)->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  368  		hvs->chan = chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  369  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  370  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  371  	set_channel_read_mode(chan, HV_CALL_DIRECT);
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  372  
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  373  	/* Use the socket buffer sizes as hints for the VMBUS ring size. For
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  374  	 * server side sockets, 'sk' is the parent socket and thus, this will
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  375  	 * allow the child sockets to inherit the size from the parent. Keep
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  376  	 * the mins to the default value and align to page size as per VMBUS
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  377  	 * requirements.
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  378  	 * For the max, the socket core library will limit the socket buffer
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  379  	 * size that can be set by the user, but, since currently, the hv_sock
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  380  	 * VMBUS ring buffer is physically contiguous allocation, restrict it
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  381  	 * further.
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  382  	 * Older versions of hv_sock host side code cannot handle bigger VMBUS
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  383  	 * ring buffer size. Use the version number to limit the change to newer
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  384  	 * versions.
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  385  	 */
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  386  	if (vmbus_proto_version < VERSION_WIN10_V5) {
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  387  		sndbuf = RINGBUFFER_HVS_SND_SIZE;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  388  		rcvbuf = RINGBUFFER_HVS_RCV_SIZE;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  389  	} else {
ac383f58f3c98de Sunil Muthuswamy 2019-05-22 @390  		sndbuf = max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  391  		sndbuf = min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
31113cc83e30924 Himadri Pandya   2019-07-25  392  		sndbuf = ALIGN(sndbuf, HV_HYP_PAGE_SIZE);
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  393  		rcvbuf = max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  394  		rcvbuf = min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
31113cc83e30924 Himadri Pandya   2019-07-25  395  		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  396  	}
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  397  
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  398  	ret = vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  399  			 conn_from_host ? new : sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  400  	if (ret != 0) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  401  		if (conn_from_host) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  402  			hvs_new->chan = NULL;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  403  			sock_put(new);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  404  		} else {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  405  			hvs->chan = NULL;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  406  		}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  407  		goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  408  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  409  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  410  	set_per_channel_state(chan, conn_from_host ? new : sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  411  	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  412  
cb359b60416701c Sunil Muthuswamy 2019-06-17  413  	/* Set the pending send size to max packet size to always get
cb359b60416701c Sunil Muthuswamy 2019-06-17  414  	 * notifications from the host when there is enough writable space.
cb359b60416701c Sunil Muthuswamy 2019-06-17  415  	 * The host is optimized to send notifications only when the pending
cb359b60416701c Sunil Muthuswamy 2019-06-17  416  	 * size boundary is crossed, and not always.
cb359b60416701c Sunil Muthuswamy 2019-06-17  417  	 */
cb359b60416701c Sunil Muthuswamy 2019-06-17  418  	hvs_set_channel_pending_send_size(chan);
cb359b60416701c Sunil Muthuswamy 2019-06-17  419  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  420  	if (conn_from_host) {
3b4477d2dcf2709 Stefan Hajnoczi  2017-10-05  421  		new->sk_state = TCP_ESTABLISHED;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  422  		sk->sk_ack_backlog++;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  423  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  424  		hvs_addr_init(&vnew->local_addr, if_type);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  425  		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  426  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  427  		hvs_new->vm_srv_id = *if_type;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  428  		hvs_new->host_srv_id = *if_instance;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  429  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  430  		vsock_insert_connected(vnew);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  431  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  432  		vsock_enqueue_accept(sk, new);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  433  	} else {
3b4477d2dcf2709 Stefan Hajnoczi  2017-10-05  434  		sk->sk_state = TCP_ESTABLISHED;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  435  		sk->sk_socket->state = SS_CONNECTED;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  436  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  437  		vsock_insert_connected(vsock_sk(sk));
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  438  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  439  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  440  	sk->sk_state_change(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  441  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  442  out:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  443  	/* Release refcnt obtained when we called vsock_find_bound_socket() */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  444  	sock_put(sk);
b4562ca7925a3be Dexuan Cui       2017-10-19  445  
b4562ca7925a3be Dexuan Cui       2017-10-19  446  	release_sock(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  447  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  448  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  449  static u32 hvs_get_local_cid(void)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  450  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  451  	return VMADDR_CID_ANY;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  452  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  453  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  454  static int hvs_sock_init(struct vsock_sock *vsk, struct vsock_sock *psk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  455  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  456  	struct hvsock *hvs;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  457  	struct sock *sk = sk_vsock(vsk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  458  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  459  	hvs = kzalloc(sizeof(*hvs), GFP_KERNEL);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  460  	if (!hvs)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  461  		return -ENOMEM;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  462  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  463  	vsk->trans = hvs;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  464  	hvs->vsk = vsk;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  465  	sk->sk_sndbuf = RINGBUFFER_HVS_SND_SIZE;
ac383f58f3c98de Sunil Muthuswamy 2019-05-22  466  	sk->sk_rcvbuf = RINGBUFFER_HVS_RCV_SIZE;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  467  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  468  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  469  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  470  static int hvs_connect(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  471  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  472  	union hvs_service_id vm, host;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  473  	struct hvsock *h = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  474  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  475  	vm.srv_id = srv_id_template;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  476  	vm.svm_port = vsk->local_addr.svm_port;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  477  	h->vm_srv_id = vm.srv_id;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  478  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  479  	host.srv_id = srv_id_template;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  480  	host.svm_port = vsk->remote_addr.svm_port;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  481  	h->host_srv_id = host.srv_id;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  482  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  483  	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  484  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  485  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  486  static void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  487  {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  488  	struct vmpipe_proto_header hdr;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  489  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  490  	if (hvs->fin_sent || !hvs->chan)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  491  		return;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  492  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  493  	/* It can't fail: see hvs_channel_writable_bytes(). */
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  494  	(void)hvs_send_data(hvs->chan, (struct hvs_send_buf *)&hdr, 0);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  495  	hvs->fin_sent = true;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  496  }
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  497  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  498  static int hvs_shutdown(struct vsock_sock *vsk, int mode)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  499  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  500  	struct sock *sk = sk_vsock(vsk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  501  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  502  	if (!(mode & SEND_SHUTDOWN))
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  503  		return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  504  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  505  	lock_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  506  	hvs_shutdown_lock_held(vsk->trans, mode);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  507  	release_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  508  	return 0;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  509  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  510  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  511  static void hvs_close_timeout(struct work_struct *work)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  512  {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  513  	struct vsock_sock *vsk =
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  514  		container_of(work, struct vsock_sock, close_work.work);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  515  	struct sock *sk = sk_vsock(vsk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  516  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  517  	sock_hold(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  518  	lock_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  519  	if (!sock_flag(sk, SOCK_DONE))
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  520  		hvs_do_close_lock_held(vsk, false);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  521  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  522  	vsk->close_work_scheduled = false;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  523  	release_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  524  	sock_put(sk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  525  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  526  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  527  /* Returns true, if it is safe to remove socket; false otherwise */
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  528  static bool hvs_close_lock_held(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  529  {
b4562ca7925a3be Dexuan Cui       2017-10-19  530  	struct sock *sk = sk_vsock(vsk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  531  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  532  	if (!(sk->sk_state == TCP_ESTABLISHED ||
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  533  	      sk->sk_state == TCP_CLOSING))
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  534  		return true;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  535  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  536  	if ((sk->sk_shutdown & SHUTDOWN_MASK) != SHUTDOWN_MASK)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  537  		hvs_shutdown_lock_held(vsk->trans, SHUTDOWN_MASK);
b4562ca7925a3be Dexuan Cui       2017-10-19  538  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  539  	if (sock_flag(sk, SOCK_DONE))
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  540  		return true;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  541  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  542  	/* This reference will be dropped by the delayed close routine */
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  543  	sock_hold(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  544  	INIT_DELAYED_WORK(&vsk->close_work, hvs_close_timeout);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  545  	vsk->close_work_scheduled = true;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  546  	schedule_delayed_work(&vsk->close_work, HVS_CLOSE_TIMEOUT);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  547  	return false;
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  548  }
b4562ca7925a3be Dexuan Cui       2017-10-19  549  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  550  static void hvs_release(struct vsock_sock *vsk)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  551  {
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  552  	struct sock *sk = sk_vsock(vsk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  553  	bool remove_sock;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  554  
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  555  	lock_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  556  	remove_sock = hvs_close_lock_held(vsk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  557  	release_sock(sk);
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  558  	if (remove_sock)
a9eeb998c28d550 Sunil Muthuswamy 2019-05-15  559  		vsock_remove_sock(vsk);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  560  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  561  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  562  static void hvs_destruct(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  563  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  564  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  565  	struct vmbus_channel *chan = hvs->chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  566  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  567  	if (chan)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  568  		vmbus_hvsock_device_unregister(chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  569  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  570  	kfree(hvs);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  571  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  572  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  573  static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  574  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  575  	return -EOPNOTSUPP;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  576  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  577  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  578  static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  579  			     size_t len, int flags)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  580  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  581  	return -EOPNOTSUPP;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  582  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  583  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  584  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  585  			     struct sockaddr_vm *remote, struct msghdr *msg,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  586  			     size_t dgram_len)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  587  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  588  	return -EOPNOTSUPP;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  589  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  590  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  591  static bool hvs_dgram_allow(u32 cid, u32 port)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  592  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  593  	return false;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  594  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  595  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  596  static int hvs_update_recv_data(struct hvsock *hvs)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  597  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  598  	struct hvs_recv_buf *recv_buf;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  599  	u32 payload_len;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  600  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  601  	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  602  	payload_len = recv_buf->hdr.data_size;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  603  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  604  	if (payload_len > HVS_MTU_SIZE)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  605  		return -EIO;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  606  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  607  	if (payload_len == 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  608  		hvs->vsk->peer_shutdown |= SEND_SHUTDOWN;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  609  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  610  	hvs->recv_data_len = payload_len;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  611  	hvs->recv_data_off = 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  612  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  613  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  614  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  615  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  616  static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  617  				  size_t len, int flags)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  618  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  619  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  620  	bool need_refill = !hvs->recv_desc;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  621  	struct hvs_recv_buf *recv_buf;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  622  	u32 to_read;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  623  	int ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  624  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  625  	if (flags & MSG_PEEK)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  626  		return -EOPNOTSUPP;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  627  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  628  	if (need_refill) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  629  		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  630  		ret = hvs_update_recv_data(hvs);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  631  		if (ret)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  632  			return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  633  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  634  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  635  	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  636  	to_read = min_t(u32, len, hvs->recv_data_len);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  637  	ret = memcpy_to_msg(msg, recv_buf->data + hvs->recv_data_off, to_read);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  638  	if (ret != 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  639  		return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  640  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  641  	hvs->recv_data_len -= to_read;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  642  	if (hvs->recv_data_len == 0) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  643  		hvs->recv_desc = hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  644  		if (hvs->recv_desc) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  645  			ret = hvs_update_recv_data(hvs);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  646  			if (ret)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  647  				return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  648  		}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  649  	} else {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  650  		hvs->recv_data_off += to_read;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  651  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  652  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  653  	return to_read;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  654  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  655  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  656  static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  657  				  size_t len)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  658  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  659  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  660  	struct vmbus_channel *chan = hvs->chan;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  661  	struct hvs_send_buf *send_buf;
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  662  	ssize_t to_write, max_writable;
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  663  	ssize_t ret = 0;
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  664  	ssize_t bytes_written = 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  665  
31113cc83e30924 Himadri Pandya   2019-07-25  666  	BUILD_BUG_ON(sizeof(*send_buf) != HV_HYP_PAGE_SIZE);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  667  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  668  	send_buf = kmalloc(sizeof(*send_buf), GFP_KERNEL);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  669  	if (!send_buf)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  670  		return -ENOMEM;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  671  
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  672  	/* Reader(s) could be draining data from the channel as we write.
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  673  	 * Maximize bandwidth, by iterating until the channel is found to be
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  674  	 * full.
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  675  	 */
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  676  	while (len) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  677  		max_writable = hvs_channel_writable_bytes(chan);
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  678  		if (!max_writable)
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  679  			break;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  680  		to_write = min_t(ssize_t, len, max_writable);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  681  		to_write = min_t(ssize_t, to_write, HVS_SEND_BUF_SIZE);
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  682  		/* memcpy_from_msg is safe for loop as it advances the offsets
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  683  		 * within the message iterator.
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  684  		 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  685  		ret = memcpy_from_msg(send_buf->data, msg, to_write);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  686  		if (ret < 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  687  			goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  688  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  689  		ret = hvs_send_data(hvs->chan, send_buf, to_write);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  690  		if (ret < 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  691  			goto out;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  692  
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  693  		bytes_written += to_write;
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  694  		len -= to_write;
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  695  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  696  out:
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  697  	/* If any data has been sent, return that */
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  698  	if (bytes_written)
14a1eaa8820e8f3 Sunil Muthuswamy 2019-05-22  699  		ret = bytes_written;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  700  	kfree(send_buf);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  701  	return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  702  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  703  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  704  static s64 hvs_stream_has_data(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  705  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  706  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  707  	s64 ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  708  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  709  	if (hvs->recv_data_len > 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  710  		return 1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  711  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  712  	switch (hvs_channel_readable_payload(hvs->chan)) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  713  	case 1:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  714  		ret = 1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  715  		break;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  716  	case 0:
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  717  		vsk->peer_shutdown |= SEND_SHUTDOWN;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  718  		ret = 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  719  		break;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  720  	default: /* -1 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  721  		ret = 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  722  		break;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  723  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  724  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  725  	return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  726  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  727  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  728  static s64 hvs_stream_has_space(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  729  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  730  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  731  
cb359b60416701c Sunil Muthuswamy 2019-06-17  732  	return hvs_channel_writable_bytes(hvs->chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  733  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  734  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  735  static u64 hvs_stream_rcvhiwat(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  736  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  737  	return HVS_MTU_SIZE + 1;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  738  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  739  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  740  static bool hvs_stream_is_active(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  741  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  742  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  743  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  744  	return hvs->chan != NULL;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  745  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  746  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  747  static bool hvs_stream_allow(u32 cid, u32 port)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  748  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  749  	/* The host's port range [MIN_HOST_EPHEMERAL_PORT, 0xFFFFFFFF) is
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  750  	 * reserved as ephemeral ports, which are used as the host's ports
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  751  	 * when the host initiates connections.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  752  	 *
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  753  	 * Perform this check in the guest so an immediate error is produced
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  754  	 * instead of a timeout.
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  755  	 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  756  	if (port > MAX_HOST_LISTEN_PORT)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  757  		return false;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  758  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  759  	if (cid == VMADDR_CID_HOST)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  760  		return true;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  761  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  762  	return false;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  763  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  764  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  765  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  766  int hvs_notify_poll_in(struct vsock_sock *vsk, size_t target, bool *readable)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  767  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  768  	struct hvsock *hvs = vsk->trans;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  769  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  770  	*readable = hvs_channel_readable(hvs->chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  771  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  772  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  773  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  774  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  775  int hvs_notify_poll_out(struct vsock_sock *vsk, size_t target, bool *writable)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  776  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  777  	*writable = hvs_stream_has_space(vsk) > 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  778  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  779  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  780  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  781  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  782  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  783  int hvs_notify_recv_init(struct vsock_sock *vsk, size_t target,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  784  			 struct vsock_transport_recv_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  785  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  786  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  787  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  788  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  789  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  790  int hvs_notify_recv_pre_block(struct vsock_sock *vsk, size_t target,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  791  			      struct vsock_transport_recv_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  792  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  793  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  794  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  795  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  796  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  797  int hvs_notify_recv_pre_dequeue(struct vsock_sock *vsk, size_t target,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  798  				struct vsock_transport_recv_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  799  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  800  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  801  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  802  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  803  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  804  int hvs_notify_recv_post_dequeue(struct vsock_sock *vsk, size_t target,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  805  				 ssize_t copied, bool data_read,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  806  				 struct vsock_transport_recv_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  807  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  808  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  809  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  810  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  811  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  812  int hvs_notify_send_init(struct vsock_sock *vsk,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  813  			 struct vsock_transport_send_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  814  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  815  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  816  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  817  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  818  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  819  int hvs_notify_send_pre_block(struct vsock_sock *vsk,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  820  			      struct vsock_transport_send_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  821  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  822  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  823  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  824  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  825  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  826  int hvs_notify_send_pre_enqueue(struct vsock_sock *vsk,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  827  				struct vsock_transport_send_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  828  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  829  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  830  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  831  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  832  static
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  833  int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  834  				 struct vsock_transport_send_notify_data *d)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  835  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  836  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  837  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  838  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  839  static void hvs_set_buffer_size(struct vsock_sock *vsk, u64 val)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  840  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  841  	/* Ignored. */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  842  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  843  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  844  static void hvs_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  845  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  846  	/* Ignored. */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  847  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  848  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  849  static void hvs_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  850  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  851  	/* Ignored. */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  852  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  853  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  854  static u64 hvs_get_buffer_size(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  855  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  856  	return -ENOPROTOOPT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  857  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  858  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  859  static u64 hvs_get_min_buffer_size(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  860  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  861  	return -ENOPROTOOPT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  862  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  863  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  864  static u64 hvs_get_max_buffer_size(struct vsock_sock *vsk)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  865  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  866  	return -ENOPROTOOPT;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  867  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  868  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  869  static struct vsock_transport hvs_transport = {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  870  	.get_local_cid            = hvs_get_local_cid,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  871  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  872  	.init                     = hvs_sock_init,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  873  	.destruct                 = hvs_destruct,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  874  	.release                  = hvs_release,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  875  	.connect                  = hvs_connect,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  876  	.shutdown                 = hvs_shutdown,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  877  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  878  	.dgram_bind               = hvs_dgram_bind,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  879  	.dgram_dequeue            = hvs_dgram_dequeue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  880  	.dgram_enqueue            = hvs_dgram_enqueue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  881  	.dgram_allow              = hvs_dgram_allow,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  882  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  883  	.stream_dequeue           = hvs_stream_dequeue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  884  	.stream_enqueue           = hvs_stream_enqueue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  885  	.stream_has_data          = hvs_stream_has_data,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  886  	.stream_has_space         = hvs_stream_has_space,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  887  	.stream_rcvhiwat          = hvs_stream_rcvhiwat,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  888  	.stream_is_active         = hvs_stream_is_active,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  889  	.stream_allow             = hvs_stream_allow,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  890  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  891  	.notify_poll_in           = hvs_notify_poll_in,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  892  	.notify_poll_out          = hvs_notify_poll_out,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  893  	.notify_recv_init         = hvs_notify_recv_init,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  894  	.notify_recv_pre_block    = hvs_notify_recv_pre_block,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  895  	.notify_recv_pre_dequeue  = hvs_notify_recv_pre_dequeue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  896  	.notify_recv_post_dequeue = hvs_notify_recv_post_dequeue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  897  	.notify_send_init         = hvs_notify_send_init,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  898  	.notify_send_pre_block    = hvs_notify_send_pre_block,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  899  	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  900  	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  901  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  902  	.set_buffer_size          = hvs_set_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  903  	.set_min_buffer_size      = hvs_set_min_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  904  	.set_max_buffer_size      = hvs_set_max_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  905  	.get_buffer_size          = hvs_get_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  906  	.get_min_buffer_size      = hvs_get_min_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  907  	.get_max_buffer_size      = hvs_get_max_buffer_size,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  908  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  909  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  910  static int hvs_probe(struct hv_device *hdev,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  911  		     const struct hv_vmbus_device_id *dev_id)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  912  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  913  	struct vmbus_channel *chan = hdev->channel;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  914  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  915  	hvs_open_connection(chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  916  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  917  	/* Always return success to suppress the unnecessary error message
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  918  	 * in vmbus_probe(): on error the host will rescind the device in
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  919  	 * 30 seconds and we can do cleanup at that time in
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  920  	 * vmbus_onoffer_rescind().
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  921  	 */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  922  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  923  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  924  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  925  static int hvs_remove(struct hv_device *hdev)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  926  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  927  	struct vmbus_channel *chan = hdev->channel;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  928  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  929  	vmbus_close(chan);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  930  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  931  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  932  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  933  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  934  /* This isn't really used. See vmbus_match() and vmbus_probe() */
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  935  static const struct hv_vmbus_device_id id_table[] = {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  936  	{},
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  937  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  938  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  939  static struct hv_driver hvs_drv = {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  940  	.name		= "hv_sock",
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  941  	.hvsock		= true,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  942  	.id_table	= id_table,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  943  	.probe		= hvs_probe,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  944  	.remove		= hvs_remove,
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  945  };
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  946  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  947  static int __init hvs_init(void)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  948  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  949  	int ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  950  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  951  	if (vmbus_proto_version < VERSION_WIN10)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  952  		return -ENODEV;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  953  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  954  	ret = vmbus_driver_register(&hvs_drv);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  955  	if (ret != 0)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  956  		return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  957  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  958  	ret = vsock_core_init(&hvs_transport);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  959  	if (ret) {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  960  		vmbus_driver_unregister(&hvs_drv);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  961  		return ret;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  962  	}
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  963  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  964  	return 0;
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  965  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  966  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  967  static void __exit hvs_exit(void)
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  968  {
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  969  	vsock_core_exit();
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  970  	vmbus_driver_unregister(&hvs_drv);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  971  }
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  972  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  973  module_init(hvs_init);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  974  module_exit(hvs_exit);
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  975  
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  976  MODULE_DESCRIPTION("Hyper-V Sockets");
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  977  MODULE_VERSION("1.0.0");
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  978  MODULE_LICENSE("GPL");
ae0078fcf0a5eb3 Dexuan Cui       2017-08-26  979  MODULE_ALIAS_NETPROTO(PF_VSOCK);

:::::: The code at line 214 was first introduced by commit
:::::: ae0078fcf0a5eb3a8623bfb5f988262e0911fdb9 hv_sock: implements Hyper-V transport for Virtual Sockets (AF_VSOCK)

:::::: TO: Dexuan Cui <decui@microsoft.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
