Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1435E2AF4F
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 09:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfE0HSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 03:18:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfE0HSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 03:18:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4R7E8Xe013427;
        Mon, 27 May 2019 07:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=Yx2VRjeZXSx6xPUb6KIMWdDqfm3521/vPjhwGK8e6PY=;
 b=xQp9V9n13S7lvHch+jTTnNt+wiho57TpDvkvWzBGARc1ykONOjNs7QAbA5O2kkFjNSYw
 V+NDbRI22zVn6frsG4PNgOVfnVA3x8HRO+1ZQ+uAzdhNrZ+hVnVZ3LZOLj5+kZ0q0PKk
 Z1kweOLT0FiTNiScNWMjL13pqhBavoeyG+OrPBiIwtUORE6xbTnst3R65nsFG4I4KBeF
 Cr9MOjQ7AJoKDgbvGV5vIzKuQIO63vy9YLT2J7Fq8/ENj++xZvQ0bPwRP/IOWdlAndmy
 bjxUaniT+QfreFJd9xk/DU/0j5xwaSzmlzDziH764EbhlYPVGAPmQi18wzJToJzFiXBZ Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2spw4t4kk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 07:17:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4R7GHat196348;
        Mon, 27 May 2019 07:17:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2sqh72j24p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 07:17:37 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4R7HYjT014017;
        Mon, 27 May 2019 07:17:34 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 May 2019 00:17:34 -0700
Date:   Mon, 27 May 2019 10:17:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     kbuild-all@01.org, grygorii.strashko@ti.com, hawk@kernel.org,
        davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190527071723.GE24680@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9269 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905270051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9269 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905270051
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Ivan-Khoronzhuk/net-ethernet-ti-cpsw-Add-XDP-support/20190524-114123

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/net/ethernet/ti/cpsw_ethtool.c:564 cpsw_xdp_rxq_reg() error: uninitialized symbol 'ret'.

# https://github.com/0day-ci/linux/commit/3cf4eb125ed19d18340fd3b0c4d7eb2f1ebdfb28
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 3cf4eb125ed19d18340fd3b0c4d7eb2f1ebdfb28
vim +/ret +564 drivers/net/ethernet/ti/cpsw_ethtool.c

c24eef28 Grygorii Strashko 2019-04-26  534  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  535  static int cpsw_xdp_rxq_reg(struct cpsw_common *cpsw, int ch)
3cf4eb12 Ivan Khoronzhuk   2019-05-23  536  {
3cf4eb12 Ivan Khoronzhuk   2019-05-23  537  	struct cpsw_slave *slave;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  538  	struct cpsw_priv *priv;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  539  	int i, ret;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  540  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  541  	/* As channels are common for both ports sharing same queues, xdp_rxq
3cf4eb12 Ivan Khoronzhuk   2019-05-23  542  	 * information also becomes shared and used by every packet on this
3cf4eb12 Ivan Khoronzhuk   2019-05-23  543  	 * channel. But exch xdp_rxq holds link on netdev, which by the theory
3cf4eb12 Ivan Khoronzhuk   2019-05-23  544  	 * can have different memory model and so, network device must hold it's
3cf4eb12 Ivan Khoronzhuk   2019-05-23  545  	 * own set of rxq and thus both netdevs should be prepared
3cf4eb12 Ivan Khoronzhuk   2019-05-23  546  	 */
3cf4eb12 Ivan Khoronzhuk   2019-05-23  547  	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
3cf4eb12 Ivan Khoronzhuk   2019-05-23  548  		if (!slave->ndev)
3cf4eb12 Ivan Khoronzhuk   2019-05-23  549  			continue;

Smatch always complains that every loop iteration could continue.  Or
that cpsw->data.slaves might be zero at the start...  It seems
implausible.

3cf4eb12 Ivan Khoronzhuk   2019-05-23  550  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  551  		priv = netdev_priv(slave->ndev);
3cf4eb12 Ivan Khoronzhuk   2019-05-23  552  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  553  		ret = xdp_rxq_info_reg(&priv->xdp_rxq[ch], priv->ndev, ch);
3cf4eb12 Ivan Khoronzhuk   2019-05-23  554  		if (ret)
3cf4eb12 Ivan Khoronzhuk   2019-05-23  555  			goto err;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  556  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  557  		ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[ch],
3cf4eb12 Ivan Khoronzhuk   2019-05-23  558  						 MEM_TYPE_PAGE_POOL,
3cf4eb12 Ivan Khoronzhuk   2019-05-23  559  						 cpsw->rx_page_pool);
3cf4eb12 Ivan Khoronzhuk   2019-05-23  560  		if (ret)
3cf4eb12 Ivan Khoronzhuk   2019-05-23  561  			goto err;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  562  	}
3cf4eb12 Ivan Khoronzhuk   2019-05-23  563  
3cf4eb12 Ivan Khoronzhuk   2019-05-23 @564  	return ret;

This would be more readable as "return 0;" anyway.

3cf4eb12 Ivan Khoronzhuk   2019-05-23  565  
3cf4eb12 Ivan Khoronzhuk   2019-05-23  566  err:
3cf4eb12 Ivan Khoronzhuk   2019-05-23  567  	cpsw_xdp_rxq_unreg(cpsw, ch);
3cf4eb12 Ivan Khoronzhuk   2019-05-23  568  	return ret;
3cf4eb12 Ivan Khoronzhuk   2019-05-23  569  }

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
