Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F167FAEF
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 21:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbjA1Ubu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 15:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbjA1Ube (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 15:31:34 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBCC298E1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 12:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674937859; x=1706473859;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=71y1W1b1xJ8x2JzNe2W+jUdox0W00D7Z1eylzyt4Inw=;
  b=CV997/f+IlQemdk7yk0a+DJJIruJ4CfJXAltyLbSLAwhpsxuqEm+C2CB
   rV5eSLT6CVKNCD0ccI9PxwxozdGPQfxxDqnpJZrYzf8QbrcAjZDYpXdtq
   ydLeLTJ/49FQTIaDYmJevUiBTzF6cDk1r8U0wAoaJCsYfSx2TMZBOmWHX
   nONm4TcTfdNKTI9iye4vGOUGk48AXV65TeQBE6AVpMcEUXAn2x8t6EO+W
   3EilOuUuvcX/h/7zozcWR6IP42CADntfFLPjobJVB/5r2cixrYveXMgPH
   YRAVUlr0PMO++2LNWbjw2YSSaHZG9J9i3OlqjnnuMcJCE7RNMNEKn+8i6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="325025760"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="325025760"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 12:30:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="837533309"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="837533309"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 28 Jan 2023 12:30:51 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLrqc-00015G-2p;
        Sat, 28 Jan 2023 20:30:50 +0000
Date:   Sun, 29 Jan 2023 04:30:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     wolfgang@linogate.de, steffen.klassert@secunet.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, Wolfgang Nothdurft <wolfgang@linogate.de>
Subject: Re: [PATCH net] xfrm: remove inherited bridge info from skb
Message-ID: <202301290439.F9s2CEim-lkp@intel.com>
References: <20230126125637.91969-1-wolfgang@linogate.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126125637.91969-1-wolfgang@linogate.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/wolfgang-linogate-de/xfrm-remove-inherited-bridge-info-from-skb/20230128-180508
patch link:    https://lore.kernel.org/r/20230126125637.91969-1-wolfgang%40linogate.de
patch subject: [PATCH net] xfrm: remove inherited bridge info from skb
config: i386-randconfig-a012-20230123 (https://download.01.org/0day-ci/archive/20230129/202301290439.F9s2CEim-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d1ea8e936ffdff6ceddc242e516a79730af3a017
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review wolfgang-linogate-de/xfrm-remove-inherited-bridge-info-from-skb/20230128-180508
        git checkout d1ea8e936ffdff6ceddc242e516a79730af3a017
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/xfrm/xfrm_input.c:545:25: error: use of undeclared identifier 'SKB_EXT_BRIDGE_NF'
           if (skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
                                  ^
   net/xfrm/xfrm_input.c:546:20: error: use of undeclared identifier 'SKB_EXT_BRIDGE_NF'
                   skb_ext_del(skb, SKB_EXT_BRIDGE_NF);
                                    ^
   2 errors generated.


vim +/SKB_EXT_BRIDGE_NF +545 net/xfrm/xfrm_input.c

   460	
   461	int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
   462	{
   463		const struct xfrm_state_afinfo *afinfo;
   464		struct net *net = dev_net(skb->dev);
   465		const struct xfrm_mode *inner_mode;
   466		int err;
   467		__be32 seq;
   468		__be32 seq_hi;
   469		struct xfrm_state *x = NULL;
   470		xfrm_address_t *daddr;
   471		u32 mark = skb->mark;
   472		unsigned int family = AF_UNSPEC;
   473		int decaps = 0;
   474		int async = 0;
   475		bool xfrm_gro = false;
   476		bool crypto_done = false;
   477		struct xfrm_offload *xo = xfrm_offload(skb);
   478		struct sec_path *sp;
   479	
   480		if (encap_type < 0) {
   481			x = xfrm_input_state(skb);
   482	
   483			if (unlikely(x->km.state != XFRM_STATE_VALID)) {
   484				if (x->km.state == XFRM_STATE_ACQ)
   485					XFRM_INC_STATS(net, LINUX_MIB_XFRMACQUIREERROR);
   486				else
   487					XFRM_INC_STATS(net,
   488						       LINUX_MIB_XFRMINSTATEINVALID);
   489	
   490				if (encap_type == -1)
   491					dev_put(skb->dev);
   492				goto drop;
   493			}
   494	
   495			family = x->outer_mode.family;
   496	
   497			/* An encap_type of -1 indicates async resumption. */
   498			if (encap_type == -1) {
   499				async = 1;
   500				seq = XFRM_SKB_CB(skb)->seq.input.low;
   501				goto resume;
   502			}
   503	
   504			/* encap_type < -1 indicates a GRO call. */
   505			encap_type = 0;
   506			seq = XFRM_SPI_SKB_CB(skb)->seq;
   507	
   508			if (xo && (xo->flags & CRYPTO_DONE)) {
   509				crypto_done = true;
   510				family = XFRM_SPI_SKB_CB(skb)->family;
   511	
   512				if (!(xo->status & CRYPTO_SUCCESS)) {
   513					if (xo->status &
   514					    (CRYPTO_TRANSPORT_AH_AUTH_FAILED |
   515					     CRYPTO_TRANSPORT_ESP_AUTH_FAILED |
   516					     CRYPTO_TUNNEL_AH_AUTH_FAILED |
   517					     CRYPTO_TUNNEL_ESP_AUTH_FAILED)) {
   518	
   519						xfrm_audit_state_icvfail(x, skb,
   520									 x->type->proto);
   521						x->stats.integrity_failed++;
   522						XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
   523						goto drop;
   524					}
   525	
   526					if (xo->status & CRYPTO_INVALID_PROTOCOL) {
   527						XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
   528						goto drop;
   529					}
   530	
   531					XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
   532					goto drop;
   533				}
   534	
   535				if (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
   536					XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
   537					goto drop;
   538				}
   539			}
   540	
   541			goto lock;
   542		}
   543	
   544		/* strip bridge info from skb */
 > 545		if (skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
   546			skb_ext_del(skb, SKB_EXT_BRIDGE_NF);
   547	
   548		family = XFRM_SPI_SKB_CB(skb)->family;
   549	
   550		/* if tunnel is present override skb->mark value with tunnel i_key */
   551		switch (family) {
   552		case AF_INET:
   553			if (XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4)
   554				mark = be32_to_cpu(XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4->parms.i_key);
   555			break;
   556		case AF_INET6:
   557			if (XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6)
   558				mark = be32_to_cpu(XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6->parms.i_key);
   559			break;
   560		}
   561	
   562		sp = secpath_set(skb);
   563		if (!sp) {
   564			XFRM_INC_STATS(net, LINUX_MIB_XFRMINERROR);
   565			goto drop;
   566		}
   567	
   568		seq = 0;
   569		if (!spi && xfrm_parse_spi(skb, nexthdr, &spi, &seq)) {
   570			secpath_reset(skb);
   571			XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
   572			goto drop;
   573		}
   574	
   575		daddr = (xfrm_address_t *)(skb_network_header(skb) +
   576					   XFRM_SPI_SKB_CB(skb)->daddroff);
   577		do {
   578			sp = skb_sec_path(skb);
   579	
   580			if (sp->len == XFRM_MAX_DEPTH) {
   581				secpath_reset(skb);
   582				XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
   583				goto drop;
   584			}
   585	
   586			x = xfrm_state_lookup(net, mark, daddr, spi, nexthdr, family);
   587			if (x == NULL) {
   588				secpath_reset(skb);
   589				XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
   590				xfrm_audit_state_notfound(skb, family, spi, seq);
   591				goto drop;
   592			}
   593	
   594			skb->mark = xfrm_smark_get(skb->mark, x);
   595	
   596			sp->xvec[sp->len++] = x;
   597	
   598			skb_dst_force(skb);
   599			if (!skb_dst(skb)) {
   600				XFRM_INC_STATS(net, LINUX_MIB_XFRMINERROR);
   601				goto drop;
   602			}
   603	
   604	lock:
   605			spin_lock(&x->lock);
   606	
   607			if (unlikely(x->km.state != XFRM_STATE_VALID)) {
   608				if (x->km.state == XFRM_STATE_ACQ)
   609					XFRM_INC_STATS(net, LINUX_MIB_XFRMACQUIREERROR);
   610				else
   611					XFRM_INC_STATS(net,
   612						       LINUX_MIB_XFRMINSTATEINVALID);
   613				goto drop_unlock;
   614			}
   615	
   616			if ((x->encap ? x->encap->encap_type : 0) != encap_type) {
   617				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMISMATCH);
   618				goto drop_unlock;
   619			}
   620	
   621			if (xfrm_replay_check(x, skb, seq)) {
   622				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
   623				goto drop_unlock;
   624			}
   625	
   626			if (xfrm_state_check_expire(x)) {
   627				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEEXPIRED);
   628				goto drop_unlock;
   629			}
   630	
   631			spin_unlock(&x->lock);
   632	
   633			if (xfrm_tunnel_check(skb, x, family)) {
   634				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
   635				goto drop;
   636			}
   637	
   638			seq_hi = htonl(xfrm_replay_seqhi(x, seq));
   639	
   640			XFRM_SKB_CB(skb)->seq.input.low = seq;
   641			XFRM_SKB_CB(skb)->seq.input.hi = seq_hi;
   642	
   643			dev_hold(skb->dev);
   644	
   645			if (crypto_done)
   646				nexthdr = x->type_offload->input_tail(x, skb);
   647			else
   648				nexthdr = x->type->input(x, skb);
   649	
   650			if (nexthdr == -EINPROGRESS)
   651				return 0;
   652	resume:
   653			dev_put(skb->dev);
   654	
   655			spin_lock(&x->lock);
   656			if (nexthdr < 0) {
   657				if (nexthdr == -EBADMSG) {
   658					xfrm_audit_state_icvfail(x, skb,
   659								 x->type->proto);
   660					x->stats.integrity_failed++;
   661				}
   662				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEPROTOERROR);
   663				goto drop_unlock;
   664			}
   665	
   666			/* only the first xfrm gets the encap type */
   667			encap_type = 0;
   668	
   669			if (xfrm_replay_recheck(x, skb, seq)) {
   670				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
   671				goto drop_unlock;
   672			}
   673	
   674			xfrm_replay_advance(x, seq);
   675	
   676			x->curlft.bytes += skb->len;
   677			x->curlft.packets++;
   678			x->lastused = ktime_get_real_seconds();
   679	
   680			spin_unlock(&x->lock);
   681	
   682			XFRM_MODE_SKB_CB(skb)->protocol = nexthdr;
   683	
   684			inner_mode = &x->inner_mode;
   685	
   686			if (x->sel.family == AF_UNSPEC) {
   687				inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
   688				if (inner_mode == NULL) {
   689					XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
   690					goto drop;
   691				}
   692			}
   693	
   694			if (xfrm_inner_mode_input(x, inner_mode, skb)) {
   695				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
   696				goto drop;
   697			}
   698	
   699			if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) {
   700				decaps = 1;
   701				break;
   702			}
   703	
   704			/*
   705			 * We need the inner address.  However, we only get here for
   706			 * transport mode so the outer address is identical.
   707			 */
   708			daddr = &x->id.daddr;
   709			family = x->outer_mode.family;
   710	
   711			err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
   712			if (err < 0) {
   713				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
   714				goto drop;
   715			}
   716			crypto_done = false;
   717		} while (!err);
   718	
   719		err = xfrm_rcv_cb(skb, family, x->type->proto, 0);
   720		if (err)
   721			goto drop;
   722	
   723		nf_reset_ct(skb);
   724	
   725		if (decaps) {
   726			sp = skb_sec_path(skb);
   727			if (sp)
   728				sp->olen = 0;
   729			if (skb_valid_dst(skb))
   730				skb_dst_drop(skb);
   731			gro_cells_receive(&gro_cells, skb);
   732			return 0;
   733		} else {
   734			xo = xfrm_offload(skb);
   735			if (xo)
   736				xfrm_gro = xo->flags & XFRM_GRO;
   737	
   738			err = -EAFNOSUPPORT;
   739			rcu_read_lock();
   740			afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode.family);
   741			if (likely(afinfo))
   742				err = afinfo->transport_finish(skb, xfrm_gro || async);
   743			rcu_read_unlock();
   744			if (xfrm_gro) {
   745				sp = skb_sec_path(skb);
   746				if (sp)
   747					sp->olen = 0;
   748				if (skb_valid_dst(skb))
   749					skb_dst_drop(skb);
   750				gro_cells_receive(&gro_cells, skb);
   751				return err;
   752			}
   753	
   754			return err;
   755		}
   756	
   757	drop_unlock:
   758		spin_unlock(&x->lock);
   759	drop:
   760		xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
   761		kfree_skb(skb);
   762		return 0;
   763	}
   764	EXPORT_SYMBOL(xfrm_input);
   765	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
