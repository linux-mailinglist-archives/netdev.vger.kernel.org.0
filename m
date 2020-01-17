Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE2F14025B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 04:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgAQDgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 22:36:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbgAQDgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 22:36:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H3XD0q043425;
        Fri, 17 Jan 2020 03:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=lCD4SmkAcOoyNEKe4OMgw30eRZH+QPRBFzB6/VSEfaI=;
 b=LERVf0B5Nx1pxzt+GAAwP3K6+S1brDf6Su5oE/BExvFQlC4RkpbnXa+x0L9zrK7TbYJL
 BJXnklKpdy+229phWM4WchNctkjjKUd8d/VY7X0HxkRyB3bwiiwtGaZkGGuKUq37Dpjj
 gGKC+5+KZVYvZUfBlkXcEClrfLolFtQDvcgju/X53Ep/pyodpIkGsdDdN+WK8/Xgsd9m
 9vYmqoP4/B7BA/YeKgjBnP7BtAl0+WexdU5UxfO4NsGbL4Vm1kKn3nrcSDllUgrfJbhy
 rQH96a4lZuWL+yoBN9E8PgIzl3/OOfefXxlZlU48zVfQdKodVdIYybP7eShXjnrDD57n ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73u67hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 03:36:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H3WuSu056710;
        Fri, 17 Jan 2020 03:36:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xk24e7xyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 03:36:24 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00H3aM6C011889;
        Fri, 17 Jan 2020 03:36:22 GMT
Received: from kadam (/10.175.29.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 19:36:21 -0800
Date:   Fri, 17 Jan 2020 06:38:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Taehee Yoo <ap420073@gmail.com>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        ap420073@gmail.com
Subject: Re: [PATCH net 4/5] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL
 for debugfs
Message-ID: <20200117033802.GA19765@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200111163743.4339-1-ap420073@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

url:    https://github.com/0day-ci/linux/commits/Taehee-Yoo/netdevsim-fix-a-several-bugs-in-netdevsim-module/20200112-004546
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git a5c3a7c0ce1a1cfab15404018933775d7222a517

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/net/netdevsim/bpf.c:246 nsim_bpf_create_prog() error: dereferencing freed memory 'state'

# https://github.com/0day-ci/linux/commit/923e31529b0b3f039f837f54c4a1bbd77793256b
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 923e31529b0b3f039f837f54c4a1bbd77793256b
vim +/state +246 drivers/net/netdevsim/bpf.c

d514f41e793d2c Jiri Pirko     2019-04-25  227  static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
b26b6946a62f37 Jiri Pirko     2019-04-12  228  				struct bpf_prog *prog)
31d3ad832948c7 Jakub Kicinski 2017-12-01  229  {
31d3ad832948c7 Jakub Kicinski 2017-12-01  230  	struct nsim_bpf_bound_prog *state;
31d3ad832948c7 Jakub Kicinski 2017-12-01  231  	char name[16];
31d3ad832948c7 Jakub Kicinski 2017-12-01  232  
31d3ad832948c7 Jakub Kicinski 2017-12-01  233  	state = kzalloc(sizeof(*state), GFP_KERNEL);
31d3ad832948c7 Jakub Kicinski 2017-12-01  234  	if (!state)
31d3ad832948c7 Jakub Kicinski 2017-12-01  235  		return -ENOMEM;
31d3ad832948c7 Jakub Kicinski 2017-12-01  236  
d514f41e793d2c Jiri Pirko     2019-04-25  237  	state->nsim_dev = nsim_dev;
31d3ad832948c7 Jakub Kicinski 2017-12-01  238  	state->prog = prog;
31d3ad832948c7 Jakub Kicinski 2017-12-01  239  	state->state = "verify";
31d3ad832948c7 Jakub Kicinski 2017-12-01  240  
31d3ad832948c7 Jakub Kicinski 2017-12-01  241  	/* Program id is not populated yet when we create the state. */
d514f41e793d2c Jiri Pirko     2019-04-25  242  	sprintf(name, "%u", nsim_dev->prog_id_gen++);
d514f41e793d2c Jiri Pirko     2019-04-25  243  	state->ddir = debugfs_create_dir(name, nsim_dev->ddir_bpf_bound_progs);
923e31529b0b3f Taehee Yoo     2020-01-11  244  	if (IS_ERR(state->ddir)) {
31d3ad832948c7 Jakub Kicinski 2017-12-01  245  		kfree(state);
                                                              ^^^^^
state is freed.

923e31529b0b3f Taehee Yoo     2020-01-11 @246  		return PTR_ERR(state->ddir);
                                                                       ^^^^^^^^^^^
Then dereferenced afterward.

31d3ad832948c7 Jakub Kicinski 2017-12-01  247  	}
31d3ad832948c7 Jakub Kicinski 2017-12-01  248  
31d3ad832948c7 Jakub Kicinski 2017-12-01  249  	debugfs_create_u32("id", 0400, state->ddir, &prog->aux->id);
31d3ad832948c7 Jakub Kicinski 2017-12-01  250  	debugfs_create_file("state", 0400, state->ddir,
31d3ad832948c7 Jakub Kicinski 2017-12-01  251  			    &state->state, &nsim_bpf_string_fops);
31d3ad832948c7 Jakub Kicinski 2017-12-01  252  	debugfs_create_bool("loaded", 0400, state->ddir, &state->is_loaded);
31d3ad832948c7 Jakub Kicinski 2017-12-01  253  
d514f41e793d2c Jiri Pirko     2019-04-25  254  	list_add_tail(&state->l, &nsim_dev->bpf_bound_progs);
31d3ad832948c7 Jakub Kicinski 2017-12-01  255  
31d3ad832948c7 Jakub Kicinski 2017-12-01  256  	prog->aux->offload->dev_priv = state;
31d3ad832948c7 Jakub Kicinski 2017-12-01  257  
31d3ad832948c7 Jakub Kicinski 2017-12-01  258  	return 0;
31d3ad832948c7 Jakub Kicinski 2017-12-01  259  }

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
