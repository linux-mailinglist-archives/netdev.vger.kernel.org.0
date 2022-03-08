Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A14D1D3B
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbiCHQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348169AbiCHQcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:32:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F013950E01;
        Tue,  8 Mar 2022 08:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646757095; x=1678293095;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=yn5995HjWAspdByzTx+VnoVEBkOJFdMxuBZAL8EVpiU=;
  b=hntdjA3R73mqLIMwxI3IkBbUqDaSWDxHN5/nNzPLGc6n3wmxZbT7nqHJ
   5FJYvXAHIhkkNKsBG8/QR/L0nL/c7PVu36L2eL8PUbIsX3BY6/oq9NYNk
   777oz6aXucp2W0KVhMkGOFeqymnbT4plrTYk5luyVgFoamPne9LyxqXSk
   kvYa4YdleCSh7rxL1qMy9fnOzbaoYd2RckEJsPLCEe0LOpTXdPkqWCsX6
   jsO1uNnV4p6i9/CBo6390VxGKn2BBshYMqo8gsbzFJuRM/DeYEKlPhJrZ
   vpDutvM9YqvTsqDOorDlTPpYCe3Vmg/NvM/68K+gZKf46nv65XwNiXnO4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="254674166"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="254674166"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 08:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="595935975"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 08 Mar 2022 08:31:32 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRckG-0001iM-8d; Tue, 08 Mar 2022 16:31:32 +0000
Date:   Wed, 9 Mar 2022 00:31:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        lei he <helei.sig11@bytedance.com>,
        Gonglei <arei.gonglei@huawei.com>
Subject: [mst-vhost:vhost 28/60]
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c:378: undefined reference
 to `rsa_parse_priv_key'
Message-ID: <202203090030.CaEQq1U8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
commit: 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9 [28/60] virtio-crypto: implement RSA algorithm
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220309/202203090030.CaEQq1U8-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
        git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
        git fetch --no-tags mst-vhost vhost
        git checkout 8a75f36b5d7a48f1c5a0b46638961c951ec6ecd9
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: drivers/crypto/virtio/virtio_crypto_akcipher_algs.o: in function `virtio_crypto_rsa_set_key':
>> drivers/crypto/virtio/virtio_crypto_akcipher_algs.c:378: undefined reference to `rsa_parse_priv_key'
>> ld: drivers/crypto/virtio/virtio_crypto_akcipher_algs.c:381: undefined reference to `rsa_parse_pub_key'


vim +378 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c

   354	
   355	static int virtio_crypto_rsa_set_key(struct crypto_akcipher *tfm,
   356					     const void *key,
   357					     unsigned int keylen,
   358					     bool private,
   359					     int padding_algo,
   360					     int hash_algo)
   361	{
   362		struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(tfm);
   363		struct virtio_crypto_rsa_ctx *rsa_ctx = &ctx->rsa_ctx;
   364		struct virtio_crypto *vcrypto;
   365		struct virtio_crypto_ctrl_header header;
   366		struct virtio_crypto_akcipher_session_para para;
   367		struct rsa_key rsa_key = {0};
   368		int node = virtio_crypto_get_current_node();
   369		uint32_t keytype;
   370		int ret;
   371	
   372		/* mpi_free will test n, just free it. */
   373		mpi_free(rsa_ctx->n);
   374		rsa_ctx->n = NULL;
   375	
   376		if (private) {
   377			keytype = VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PRIVATE;
 > 378			ret = rsa_parse_priv_key(&rsa_key, key, keylen);
   379		} else {
   380			keytype = VIRTIO_CRYPTO_AKCIPHER_KEY_TYPE_PUBLIC;
 > 381			ret = rsa_parse_pub_key(&rsa_key, key, keylen);
   382		}
   383	
   384		if (ret)
   385			return ret;
   386	
   387		rsa_ctx->n = mpi_read_raw_data(rsa_key.n, rsa_key.n_sz);
   388		if (!rsa_ctx->n)
   389			return -ENOMEM;
   390	
   391		if (!ctx->vcrypto) {
   392			vcrypto = virtcrypto_get_dev_node(node, VIRTIO_CRYPTO_SERVICE_AKCIPHER,
   393							VIRTIO_CRYPTO_AKCIPHER_RSA);
   394			if (!vcrypto) {
   395				pr_err("virtio_crypto: Could not find a virtio device in the system or unsupported algo\n");
   396				return -ENODEV;
   397			}
   398	
   399			ctx->vcrypto = vcrypto;
   400		} else {
   401			virtio_crypto_alg_akcipher_close_session(ctx);
   402		}
   403	
   404		/* set ctrl header */
   405		header.opcode =	cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_CREATE_SESSION);
   406		header.algo = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_RSA);
   407		header.queue_id = 0;
   408	
   409		/* set RSA para */
   410		para.algo = cpu_to_le32(VIRTIO_CRYPTO_AKCIPHER_RSA);
   411		para.keytype = cpu_to_le32(keytype);
   412		para.keylen = cpu_to_le32(keylen);
   413		para.u.rsa.padding_algo = cpu_to_le32(padding_algo);
   414		para.u.rsa.hash_algo = cpu_to_le32(hash_algo);
   415	
   416		return virtio_crypto_alg_akcipher_init_session(ctx, &header, &para, key, keylen);
   417	}
   418	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
