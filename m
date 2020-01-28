Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13E514AE6D
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 04:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgA1Ddp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 22:33:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1Ddp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 22:33:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3S5Ns001927;
        Tue, 28 Jan 2020 03:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=Nr7BQpdUONE47IibUeMZ7q+ndlt/7dgoh1WHBUaOUEE=;
 b=Mq0qwbm+JIcGdVF1wAk4kMmoNoIJQGo8DLETTDyojDh/2SvOjCv5q44ISCYRQDnivZ4X
 hc89sY8knzZGDkhBQNkH8RD53WBqjy5/jB35ppGP3NPA3vVyLM9KkQEUkKfAbOqjlZtY
 wVgdatpJqcHozD61VIo4CZm9xXNLI0YzdLWH9aGhIWt55/wdCBIGoMWxxA/IKMHqwNew
 9qAVRWTTgL+yCumVzJrCnk0M/DgikpZWUyhRUoTEcAV0PUNfOFpKDjcTZHYzG8IeTBHD
 da/2rHL/P4X7WShZDRUsBfHu1W+pFJPmGzWJyZHODHuFTnV/yKmYb8uOg82oLRzgr3V7 nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xrd3u3db6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:33:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3SgiB022942;
        Tue, 28 Jan 2020 03:33:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xryuar7cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:33:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00S3WuGE008383;
        Tue, 28 Jan 2020 03:32:56 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 19:32:52 -0800
Date:   Tue, 28 Jan 2020 06:32:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Jason Wang <jasowang@redhat.com>
Cc:     kbuild-all@lists.01.org, mst@redhat.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
Message-ID: <20200128033215.GO1870@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116124231.20253-6-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

url:    https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-support/20200117-170243
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/virtio/vdpa/vdpa_sim.c:288 vdpasim_alloc_coherent() warn: returning freed memory 'addr'

# https://github.com/0day-ci/linux/commit/55047769b3e974d68b2aab5ce0022459b172a23f
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 55047769b3e974d68b2aab5ce0022459b172a23f
vim +/addr +288 drivers/virtio/vdpa/vdpa_sim.c

55047769b3e974 Jason Wang 2020-01-16  263  static void *vdpasim_alloc_coherent(struct device *dev, size_t size,
55047769b3e974 Jason Wang 2020-01-16  264  				    dma_addr_t *dma_addr, gfp_t flag,
55047769b3e974 Jason Wang 2020-01-16  265  				    unsigned long attrs)
55047769b3e974 Jason Wang 2020-01-16  266  {
55047769b3e974 Jason Wang 2020-01-16  267  	struct vdpa_device *vdpa = dev_to_vdpa(dev);
55047769b3e974 Jason Wang 2020-01-16  268  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
55047769b3e974 Jason Wang 2020-01-16  269  	struct vhost_iotlb *iommu = vdpasim->iommu;
55047769b3e974 Jason Wang 2020-01-16  270  	void *addr = kmalloc(size, flag);
55047769b3e974 Jason Wang 2020-01-16  271  	int ret;
55047769b3e974 Jason Wang 2020-01-16  272  
55047769b3e974 Jason Wang 2020-01-16  273  	if (!addr)
55047769b3e974 Jason Wang 2020-01-16  274  		*dma_addr = DMA_MAPPING_ERROR;
55047769b3e974 Jason Wang 2020-01-16  275  	else {
55047769b3e974 Jason Wang 2020-01-16  276  		u64 pa = virt_to_phys(addr);
55047769b3e974 Jason Wang 2020-01-16  277  
55047769b3e974 Jason Wang 2020-01-16  278  		ret = vhost_iotlb_add_range(iommu, (u64)pa,
55047769b3e974 Jason Wang 2020-01-16  279  					    (u64)pa + size - 1,
55047769b3e974 Jason Wang 2020-01-16  280  					    pa, VHOST_MAP_RW);
55047769b3e974 Jason Wang 2020-01-16  281  		if (ret) {
55047769b3e974 Jason Wang 2020-01-16  282  			kfree(addr);
                                                                ^^^^^^^^^^^
55047769b3e974 Jason Wang 2020-01-16  283  			*dma_addr = DMA_MAPPING_ERROR;
55047769b3e974 Jason Wang 2020-01-16  284  		} else
55047769b3e974 Jason Wang 2020-01-16  285  			*dma_addr = (dma_addr_t)pa;
55047769b3e974 Jason Wang 2020-01-16  286  	}
55047769b3e974 Jason Wang 2020-01-16  287  
55047769b3e974 Jason Wang 2020-01-16 @288  	return addr;
                                                ^^^^^^^^^^^^
55047769b3e974 Jason Wang 2020-01-16  289  }

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
