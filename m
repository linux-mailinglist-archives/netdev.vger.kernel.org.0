Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE66A5CC6
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjB1QIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjB1QIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:08:20 -0500
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346CC17D;
        Tue, 28 Feb 2023 08:08:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VcjxrOm_1677600490;
Received: from 30.13.181.20(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VcjxrOm_1677600490)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 00:08:10 +0800
Message-ID: <ae59d74d-4654-9837-af0b-2404db507da5@linux.alibaba.com>
Date:   Wed, 1 Mar 2023 00:08:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH bpf-next v3 3/4] net/smc: add BPF injection on smc
 negotiation
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1677576294-33411-4-git-send-email-alibuda@linux.alibaba.com>
 <202302282100.x7qq7PGX-lkp@intel.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <202302282100.x7qq7PGX-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You are right. Thanks for you test!!
I will send new version to fix this.!


On 2/28/23 10:08 PM, kernel test robot wrote:
> Hi Wythe,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-move-smc_sock-related-structure-definition/20230228-173007
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> patch link:    https://lore.kernel.org/r/1677576294-33411-4-git-send-email-alibuda%40linux.alibaba.com
> patch subject: [PATCH bpf-next v3 3/4] net/smc: add BPF injection on smc negotiation
> config: x86_64-randconfig-a015-20230227 (https://download.01.org/0day-ci/archive/20230228/202302282100.x7qq7PGX-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=1 build):
>          # https://github.com/intel-lab-lkp/linux/commit/aa482ab82f4bf9b99d490f8ba5d88e1491156ccf
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review D-Wythe/net-smc-move-smc_sock-related-structure-definition/20230228-173007
>          git checkout aa482ab82f4bf9b99d490f8ba5d88e1491156ccf
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          make W=1 O=build_dir ARCH=x86_64 olddefconfig
>          make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202302282100.x7qq7PGX-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     ld: net/smc/af_smc.o: in function `smc_hs_congested':
>>> net/smc/af_smc.c:169: undefined reference to `smc_sock_should_select_smc'
>     ld: net/smc/af_smc.o: in function `smc_release':
>>> net/smc/af_smc.c:327: undefined reference to `smc_sock_perform_collecting_info'
>     ld: net/smc/af_smc.o: in function `smc_connect':
>     net/smc/af_smc.c:1637: undefined reference to `smc_sock_should_select_smc'
> 
> 
> vim +169 net/smc/af_smc.c
> 
>     156	
>     157	static bool smc_hs_congested(const struct sock *sk)
>     158	{
>     159		const struct smc_sock *smc;
>     160	
>     161		smc = smc_clcsock_user_data(sk);
>     162	
>     163		if (!smc)
>     164			return true;
>     165	
>     166		if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
>     167			return true;
>     168	
>   > 169		if (!smc_sock_should_select_smc(smc))
>     170			return true;
>     171	
>     172		return false;
>     173	}
>     174	
>     175	static struct smc_hashinfo smc_v4_hashinfo = {
>     176		.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
>     177	};
>     178	
>     179	static struct smc_hashinfo smc_v6_hashinfo = {
>     180		.lock = __RW_LOCK_UNLOCKED(smc_v6_hashinfo.lock),
>     181	};
>     182	
>     183	int smc_hash_sk(struct sock *sk)
>     184	{
>     185		struct smc_hashinfo *h = sk->sk_prot->h.smc_hash;
>     186		struct hlist_head *head;
>     187	
>     188		head = &h->ht;
>     189	
>     190		write_lock_bh(&h->lock);
>     191		sk_add_node(sk, head);
>     192		write_unlock_bh(&h->lock);
>     193		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
>     194	
>     195		return 0;
>     196	}
>     197	EXPORT_SYMBOL_GPL(smc_hash_sk);
>     198	
>     199	void smc_unhash_sk(struct sock *sk)
>     200	{
>     201		struct smc_hashinfo *h = sk->sk_prot->h.smc_hash;
>     202	
>     203		write_lock_bh(&h->lock);
>     204		if (sk_del_node_init(sk))
>     205			sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>     206		write_unlock_bh(&h->lock);
>     207	}
>     208	EXPORT_SYMBOL_GPL(smc_unhash_sk);
>     209	
>     210	/* This will be called before user really release sock_lock. So do the
>     211	 * work which we didn't do because of user hold the sock_lock in the
>     212	 * BH context
>     213	 */
>     214	static void smc_release_cb(struct sock *sk)
>     215	{
>     216		struct smc_sock *smc = smc_sk(sk);
>     217	
>     218		if (smc->conn.tx_in_release_sock) {
>     219			smc_tx_pending(&smc->conn);
>     220			smc->conn.tx_in_release_sock = false;
>     221		}
>     222	}
>     223	
>     224	struct proto smc_proto = {
>     225		.name		= "SMC",
>     226		.owner		= THIS_MODULE,
>     227		.keepalive	= smc_set_keepalive,
>     228		.hash		= smc_hash_sk,
>     229		.unhash		= smc_unhash_sk,
>     230		.release_cb	= smc_release_cb,
>     231		.obj_size	= sizeof(struct smc_sock),
>     232		.h.smc_hash	= &smc_v4_hashinfo,
>     233		.slab_flags	= SLAB_TYPESAFE_BY_RCU,
>     234	};
>     235	EXPORT_SYMBOL_GPL(smc_proto);
>     236	
>     237	struct proto smc_proto6 = {
>     238		.name		= "SMC6",
>     239		.owner		= THIS_MODULE,
>     240		.keepalive	= smc_set_keepalive,
>     241		.hash		= smc_hash_sk,
>     242		.unhash		= smc_unhash_sk,
>     243		.release_cb	= smc_release_cb,
>     244		.obj_size	= sizeof(struct smc_sock),
>     245		.h.smc_hash	= &smc_v6_hashinfo,
>     246		.slab_flags	= SLAB_TYPESAFE_BY_RCU,
>     247	};
>     248	EXPORT_SYMBOL_GPL(smc_proto6);
>     249	
>     250	static void smc_fback_restore_callbacks(struct smc_sock *smc)
>     251	{
>     252		struct sock *clcsk = smc->clcsock->sk;
>     253	
>     254		write_lock_bh(&clcsk->sk_callback_lock);
>     255		clcsk->sk_user_data = NULL;
>     256	
>     257		smc_clcsock_restore_cb(&clcsk->sk_state_change, &smc->clcsk_state_change);
>     258		smc_clcsock_restore_cb(&clcsk->sk_data_ready, &smc->clcsk_data_ready);
>     259		smc_clcsock_restore_cb(&clcsk->sk_write_space, &smc->clcsk_write_space);
>     260		smc_clcsock_restore_cb(&clcsk->sk_error_report, &smc->clcsk_error_report);
>     261	
>     262		write_unlock_bh(&clcsk->sk_callback_lock);
>     263	}
>     264	
>     265	static void smc_restore_fallback_changes(struct smc_sock *smc)
>     266	{
>     267		if (smc->clcsock->file) { /* non-accepted sockets have no file yet */
>     268			smc->clcsock->file->private_data = smc->sk.sk_socket;
>     269			smc->clcsock->file = NULL;
>     270			smc_fback_restore_callbacks(smc);
>     271		}
>     272	}
>     273	
>     274	static int __smc_release(struct smc_sock *smc)
>     275	{
>     276		struct sock *sk = &smc->sk;
>     277		int rc = 0;
>     278	
>     279		if (!smc->use_fallback) {
>     280			rc = smc_close_active(smc);
>     281			sock_set_flag(sk, SOCK_DEAD);
>     282			sk->sk_shutdown |= SHUTDOWN_MASK;
>     283		} else {
>     284			if (sk->sk_state != SMC_CLOSED) {
>     285				if (sk->sk_state != SMC_LISTEN &&
>     286				    sk->sk_state != SMC_INIT)
>     287					sock_put(sk); /* passive closing */
>     288				if (sk->sk_state == SMC_LISTEN) {
>     289					/* wake up clcsock accept */
>     290					rc = kernel_sock_shutdown(smc->clcsock,
>     291								  SHUT_RDWR);
>     292				}
>     293				sk->sk_state = SMC_CLOSED;
>     294				sk->sk_state_change(sk);
>     295			}
>     296			smc_restore_fallback_changes(smc);
>     297		}
>     298	
>     299		sk->sk_prot->unhash(sk);
>     300	
>     301		if (sk->sk_state == SMC_CLOSED) {
>     302			if (smc->clcsock) {
>     303				release_sock(sk);
>     304				smc_clcsock_release(smc);
>     305				lock_sock(sk);
>     306			}
>     307			if (!smc->use_fallback)
>     308				smc_conn_free(&smc->conn);
>     309		}
>     310	
>     311		return rc;
>     312	}
>     313	
>     314	static int smc_release(struct socket *sock)
>     315	{
>     316		struct sock *sk = sock->sk;
>     317		struct smc_sock *smc;
>     318		int old_state, rc = 0;
>     319	
>     320		if (!sk)
>     321			goto out;
>     322	
>     323		sock_hold(sk); /* sock_put below */
>     324		smc = smc_sk(sk);
>     325	
>     326		/* trigger info gathering if needed.*/
>   > 327		smc_sock_perform_collecting_info(sk, SMC_SOCK_CLOSED_TIMING);
>     328	
>     329		old_state = sk->sk_state;
>     330	
>     331		/* cleanup for a dangling non-blocking connect */
>     332		if (smc->connect_nonblock && old_state == SMC_INIT)
>     333			tcp_abort(smc->clcsock->sk, ECONNABORTED);
>     334	
>     335		if (cancel_work_sync(&smc->connect_work))
>     336			sock_put(&smc->sk); /* sock_hold in smc_connect for passive closing */
>     337	
>     338		if (sk->sk_state == SMC_LISTEN)
>     339			/* smc_close_non_accepted() is called and acquires
>     340			 * sock lock for child sockets again
>     341			 */
>     342			lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
>     343		else
>     344			lock_sock(sk);
>     345	
>     346		if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
>     347		    !smc->use_fallback)
>     348			smc_close_active_abort(smc);
>     349	
>     350		rc = __smc_release(smc);
>     351	
>     352		/* detach socket */
>     353		sock_orphan(sk);
>     354		sock->sk = NULL;
>     355		release_sock(sk);
>     356	
>     357		sock_put(sk); /* sock_hold above */
>     358		sock_put(sk); /* final sock_put */
>     359	out:
>     360		return rc;
>     361	}
>     362	
> 
