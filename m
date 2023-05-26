Return-Path: <netdev+bounces-5595-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BA8712368
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537132815B0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EAB10967;
	Fri, 26 May 2023 09:23:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7712910953
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:23:38 +0000 (UTC)
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCEEE5B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:23:15 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
	by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q7Ap6i029663;
	Fri, 26 May 2023 10:22:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=jan2016.eng;
 bh=JeOzsllBbEWZZrionW4usIEazmFAEqk6AA7pQU/1AKY=;
 b=F/gc7dQ47el/b5XIyfhK3m4MZPuz20P/944pAdsJ4bpshspu0hwubh7+dPICQ6VveR9F
 ItOzxUulC9sN+UDy25kQnb63EHag01kR0LxKMOGvlFHPCZmN5Fr7u/tc8PZ1oLq5i12J
 9i3djBasTmhdAG2kTyoAgOih3r33vHcuqGJ6k/HRUuiX5vAfm6SjD3xZM7Jzl8govMQT
 QgzkWqurkTEArCC/8xJcThV3a03Fchlh/8+hR9cUOtK8r3gPbwvVWmp3eZu+XQoF6r/x
 LdnPDq3UbIVJc7U3fba9ik8W3NMd6RdJyqCwo1/7aCmdv2UuZLJ5QFrKtYEwZD6DbIIw 3Q== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
	by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3qpnffs43c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 10:22:57 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q7BT4Y015014;
	Fri, 26 May 2023 02:22:56 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3qpv697cyr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 02:22:56 -0700
Received: from localhost (172.27.164.43) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 05:22:55 -0400
Date: Fri, 26 May 2023 10:22:52 +0100
From: Max Tottenham <mtottenh@akamai.com>
To: kernel test robot <lkp@intel.com>
CC: <netdev@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>,
        Jamal Hadi
 Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>,
        Amir Vadai <amir@vadai.me>, Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] net/sched: act_pedit: Parse L3 Header for L4 offset
Message-ID: <5jy7yqufzneqh5lqwvx6uofgs3ux4xp5vdb36fihkip53kn44j@nlmwrar4r5bz>
References: <20230525164741.4188115-1-mtottenh@akamai.com>
 <202305261541.N165u9TZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202305261541.N165u9TZ-lkp@intel.com>
X-Originating-IP: [172.27.164.43]
X-ClientProxiedBy: usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260080
X-Proofpoint-ORIG-GUID: hqBqX6m4cuIrisWUWG3oyZLKeNQP2Eg4
X-Proofpoint-GUID: hqBqX6m4cuIrisWUWG3oyZLKeNQP2Eg4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260080
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/26, kernel test robot wrote:
> Hi Max,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on net/main]
> [also build test ERROR on net-next/main linus/master v6.4-rc3 next-20230525]
> [cannot apply to horms-ipvs/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information ]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Max-Tottenham/net-sched-act_pedit-Parse-L3-Header-for-L4-offset/20230526-020135 
> base:   net/main
> patch link:    https://lore.kernel.org/r/20230525164741.4188115-1-mtottenh%40akamai.com 
> patch subject: [PATCH] net/sched: act_pedit: Parse L3 Header for L4 offset
> config: mips-allyesconfig https://download.01.org/0day-ci/archive/20230526/202305261541.N165u9TZ-lkp@intel.com/config )
> compiler: mips-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         mkdir -p ~/bin
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/dc60ecbe9b4432221ba2109d4ca1956f47d5c5d6 
>         git remote add linux-review https://github.com/intel-lab-lkp/linux 
>         git fetch --no-tags linux-review Max-Tottenham/net-sched-act_pedit-Parse-L3-Header-for-L4-offset/20230526-020135
>         git checkout dc60ecbe9b4432221ba2109d4ca1956f47d5c5d6
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305261541.N165u9TZ-lkp@intel.com/ 
> 
> All errors (new ones prefixed by >>):
> 
>    net/sched/act_pedit.c: In function 'tcf_pedit_act':
> >> net/sched/act_pedit.c:428:17: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
>      428 |                 rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
>          |                 ^~
>          |                 rq
>    net/sched/act_pedit.c:428:17: note: each undeclared identifier is reported only once for each function it appears in
> 
> 
> vim +428 net/sched/act_pedit.c
> 
>    386	
>    387	TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>    388					    const struct tc_action *a,
>    389					    struct tcf_result *res)
>    390	{
>    391		enum pedit_header_type htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
>    392		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
>    393		struct tcf_pedit *p = to_pedit(a);
>    394		struct tcf_pedit_key_ex *tkey_ex;
>    395		struct tcf_pedit_parms *parms;
>    396		struct tc_pedit_key *tkey;
>    397		u32 max_offset;
>    398		int i;
>    399	
>    400		parms = rcu_dereference_bh(p->parms);
>    401	
>    402		max_offset = (skb_transport_header_was_set(skb) ?
>    403			      skb_transport_offset(skb) :
>    404			      skb_network_offset(skb)) +
>    405			     parms->tcfp_off_max_hint;
>    406		if (skb_ensure_writable(skb, min(skb->len, max_offset)))
>    407			goto done;
>    408	
>    409		tcf_lastuse_update(&p->tcf_tm);
>    410		tcf_action_update_bstats(&p->common, skb);
>    411	
>    412		tkey = parms->tcfp_keys;
>    413		tkey_ex = parms->tcfp_keys_ex;
>    414	
>    415		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
>    416			int offset = tkey->off;
>    417			int hoffset = 0;
>    418			u32 *ptr, hdata;
>    419			u32 val;
>    420	
>    421			if (tkey_ex) {
>    422				htype = tkey_ex->htype;
>    423				cmd = tkey_ex->cmd;
>    424	
>    425				tkey_ex++;
>    426			}
>    427	
>  > 428			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);

Ah yep looks like I made an omission while bringing back the rate limited
error message. Will respin a V2 with the fix.

>    429			if (rc) {
>    430				pr_info_ratelimited("tc action pedit unable to extract header offset for header type (0x%x)\n", htype);
>    431				goto bad;
>    432			}
>    433	
>    434			if (tkey->offmask) {
>    435				u8 *d, _d;
>    436	
>    437				if (!offset_valid(skb, hoffset + tkey->at)) {
>    438					pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
>    439							    hoffset + tkey->at);
>    440					goto bad;
>    441				}
>    442				d = skb_header_pointer(skb, hoffset + tkey->at,
>    443						       sizeof(_d), &_d);
>    444				if (!d)
>    445					goto bad;
>    446	
>    447				offset += (*d & tkey->offmask) >> tkey->shift;
>    448				if (offset % 4) {
>    449					pr_info_ratelimited("tc action pedit offset must be on 32 bit boundaries\n");
>    450					goto bad;
>    451				}
>    452			}
>    453	
>    454			if (!offset_valid(skb, hoffset + offset)) {
>    455				pr_info_ratelimited("tc action pedit offset %d out of bounds\n", hoffset + offset);
>    456				goto bad;
>    457			}
>    458	
>    459			ptr = skb_header_pointer(skb, hoffset + offset,
>    460						 sizeof(hdata), &hdata);
>    461			if (!ptr)
>    462				goto bad;
>    463			/* just do it, baby */
>    464			switch (cmd) {
>    465			case TCA_PEDIT_KEY_EX_CMD_SET:
>    466				val = tkey->val;
>    467				break;
>    468			case TCA_PEDIT_KEY_EX_CMD_ADD:
>    469				val = (*ptr + tkey->val) & ~tkey->mask;
>    470				break;
>    471			default:
>    472				pr_info_ratelimited("tc action pedit bad command (%d)\n", cmd);
>    473				goto bad;
>    474			}
>    475	
>    476			*ptr = ((*ptr & tkey->mask) ^ val);
>    477			if (ptr == &hdata)
>    478				skb_store_bits(skb, hoffset + offset, ptr, 4);
>    479		}
>    480	
>    481		goto done;
>    482	
>    483	bad:
>    484		tcf_action_inc_overlimit_qstats(&p->common);
>    485	done:
>    486		return p->tcf_action;
>    487	}
>    488	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki 

-- 
Max Tottenham | Senior Software Engineer
/(* Akamai Technologies

