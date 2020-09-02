Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52025B625
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIBVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:51:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726226AbgIBVvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:51:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082LWBs4006821
        for <netdev@vger.kernel.org>; Wed, 2 Sep 2020 17:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VQo+R1xI8985PY/xRtCWULq2ieb2CppaD68xL5dOaIE=;
 b=gpLoHAY+Ip5/aMSVOiaWNwh4roxOhCeW63F3HBTIBaxT22heRinMIWnzgM/1XK2Fk5fj
 1kCBjwjhlocjfD/9fBbgM0Xbf4CoBBp0QuPczcUb/X/gecsFvMeBwUgejbyVZ650jrYZ
 ndDqDpeKF17UibmQiXKt+2hHXhPQVJKHZPHRUn6dhGTT6RgGAJLPhu/N/Yo4vPNJq5jj
 VamD9qy+SVH9pk1gtIB/FLwSxYeLnNGr+XjuNd+2hlOWyy0htlBtF7+b2+FrdmLV+iRm
 8+H7SBNPSFIKTg95Kxgrtu6DD3Jq+W6rEXMvUvHe/Xkxmj/qMGae9NfhXiyrwaz78a1S GQ== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ajxb15q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 17:51:07 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 082Lm1wM029196
        for <netdev@vger.kernel.org>; Wed, 2 Sep 2020 21:51:07 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 337en9ku56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 21:51:07 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 082Lp6eg48366072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 21:51:06 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C1E1112065;
        Wed,  2 Sep 2020 21:51:06 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03275112062;
        Wed,  2 Sep 2020 21:51:05 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.203.167])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 21:51:05 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id CA8532E0D29; Wed,  2 Sep 2020 14:51:02 -0700 (PDT)
Date:   Wed, 2 Sep 2020 14:51:02 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 4/5] ibmvnic: Reporting device ACL settings
 through sysfs
Message-ID: <20200902215102.GA1317974@us.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
 <1598893093-14280-5-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598893093-14280-5-git-send-email-tlfalcon@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 clxscore=1011 spamscore=0 impostorscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Falcon [tlfalcon@linux.ibm.com] wrote:
> Access Control Lists can be defined for each IBM VNIC
> adapter at time of creation. MAC address and VLAN ID's
> may be specified, as well as a Port VLAN ID (PVID).
> These may all be requested though read-only sysfs files:
> mac_acl, vlan_acl, and pvid. When these files are read,
> a series of Command-Response Queue (CRQ) commands is sent to
> firmware. The first command requests the size of the ACL
> data. The driver allocates a buffer of this size and passes
> the address in a second CRQ command to firmware, which then
> writes the ACL data to this buffer. This data is then parsed
> and printed to the respective sysfs file.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 199 +++++++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/ibm/ibmvnic.h |  26 ++++-
>  2 files changed, 222 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 91b9cc3..36dfa69 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1163,6 +1163,60 @@ static int __ibmvnic_open(struct net_device *netdev)
>  	return rc;
>  }
> 
> +static int ibmvnic_query_acl_sz(struct ibmvnic_adapter *adapter)
> +{
> +	union ibmvnic_crq crq;
> +
> +	memset(&crq, 0, sizeof(crq));
> +	crq.acl_query.first = IBMVNIC_CRQ_CMD;
> +	crq.acl_query.cmd = ACL_QUERY;
> +
> +	if (ibmvnic_send_crq(adapter, &crq))
> +		return -EIO;
> +	return 0;
> +}
> +
> +static int ibmvnic_request_acl_buf(struct ibmvnic_adapter *adapter)
> +{
> +	struct device *dev = &adapter->vdev->dev;
> +	union ibmvnic_crq rcrq;
> +	int rc;
> +
> +	rc = 0;
> +	adapter->acl_buf = kmalloc(adapter->acl_buf_sz, GFP_KERNEL);
> +	if (!adapter->acl_buf) {
> +		rc = -ENOMEM;
> +		goto acl_alloc_err;
> +	}
> +	adapter->acl_buf_token = dma_map_single(dev, adapter->acl_buf,
> +						adapter->acl_buf_sz,
> +						DMA_FROM_DEVICE);
> +	if (dma_mapping_error(dev, adapter->acl_buf_token)) {
> +		rc = -ENOMEM;
> +		goto acl_dma_err;
> +	}
> +	memset(&rcrq, 0, sizeof(rcrq));
> +	rcrq.acl_query.first = IBMVNIC_CRQ_CMD;
> +	rcrq.acl_query.cmd = ACL_QUERY;
> +	rcrq.acl_query.ioba = cpu_to_be32(adapter->acl_buf_token);
> +	rcrq.acl_query.len = cpu_to_be32(adapter->acl_buf_sz);
> +	if (ibmvnic_send_crq(adapter, &rcrq)) {
> +		rc = -EIO;
> +		goto acl_query_err;
> +	}
> +	return 0;
> +acl_query_err:
> +	dma_unmap_single(dev, adapter->acl_buf_token,
> +			 adapter->acl_buf_sz, DMA_FROM_DEVICE);
> +	adapter->acl_buf_token = 0;
> +	adapter->acl_buf_sz = 0;
> +acl_dma_err:
> +	kfree(adapter->acl_buf);
> +	adapter->acl_buf = NULL;
> +acl_alloc_err:
> +	return rc;
> +}
> +
>  static int ibmvnic_open(struct net_device *netdev)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
> @@ -4635,6 +4689,25 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
>  	return rc;
>  }
> 
> +static void handle_acl_query_rsp(struct ibmvnic_adapter *adapter,
> +				 union ibmvnic_crq *crq)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	u8 rcode;
> +
> +	rcode = crq->acl_query_rsp.rc.code;
> +	adapter->fw_done_rc = rcode;
> +	/* NOMEMORY is returned when ACL buffer size request is successful */
> +	if (rcode == NOMEMORY) {
> +		adapter->acl_buf_sz = be32_to_cpu(crq->acl_query_rsp.len);
> +		netdev_dbg(netdev, "ACL buffer size is %d.\n",
> +			   adapter->acl_buf_sz);
> +	} else if (rcode != SUCCESS) {
> +		netdev_err(netdev, "ACL query failed, rc = %u\n", rcode);
> +	}
> +	complete(&adapter->fw_done);
> +}
> +
>  static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
>  			       struct ibmvnic_adapter *adapter)
>  {
> @@ -4798,6 +4871,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
>  		adapter->fw_done_rc = handle_query_phys_parms_rsp(crq, adapter);
>  		complete(&adapter->fw_done);
>  		break;
> +	case ACL_QUERY_RSP:
> +		handle_acl_query_rsp(adapter, crq);
> +		break;
>  	default:
>  		netdev_err(netdev, "Got an invalid cmd type 0x%02x\n",
>  			   gen_crq->cmd);
> @@ -5199,6 +5275,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  }
> 
>  static struct device_attribute dev_attr_failover;
> +static struct device_attribute dev_attr_vlan_acl;
> +static struct device_attribute dev_attr_mac_acl;
> +static struct device_attribute dev_attr_pvid;
> 
>  static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
>  			      const char *buf, size_t count)
> @@ -5234,10 +5313,130 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
>  	return count;
>  }
> 
> +static int ibmvnic_get_acls(struct ibmvnic_adapter *adapter)
> +{
> +	struct net_device *netdev = adapter->netdev;
> +	int rc;
> +
> +	mutex_lock(&adapter->fw_lock);

Would it be better to hold this lock in the caller acl_show() instead?
If we get back to back calls to acl_show(), the thread in acl_show()
could free the adapter->acl_buf while this function is still using?

> +	reinit_completion(&adapter->fw_done);
> +	adapter->fw_done_rc = 0;
> +	rc = ibmvnic_query_acl_sz(adapter);
> +	if (rc) {
> +		netdev_err(netdev, "Query ACL buffer size failed, rc = %d\n",
> +			   rc);
> +		goto out;
> +	}
> +	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
> +	if (rc) {
> +		netdev_err(netdev,
> +			   "Query ACL buffer size did not complete, rc = %d\n",
> +			   rc);
> +		goto out;
> +	}
> +	/* NOMEMORY is returned when the ACL buffer size is retrieved
> +	 * successfully
> +	 */
> +	if (adapter->fw_done_rc != NOMEMORY) {
> +		netdev_err(netdev, "Unable to get ACL buffer size, rc = %d\n",
> +			   adapter->fw_done_rc);
> +		rc = -EIO;
> +		goto out;
> +	}
> +	reinit_completion(&adapter->fw_done);
> +	rc = ibmvnic_request_acl_buf(adapter);
> +	if (rc) {
> +		netdev_err(netdev, "ACL buffer request failed, rc = %d\n", rc);
> +		goto out;
> +	}
> +	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
> +	if (rc) {
> +		netdev_err(netdev,
> +			   "ACL buffer request did not complete, rc = %d\n",
> +			   rc);
> +		goto out;
> +	}
> +	if (adapter->fw_done_rc != SUCCESS) {
> +		netdev_err(netdev, "Unable to retrieve ACL buffer, rc = %d\n",
> +			   adapter->fw_done_rc);
> +		rc = -EIO;
> +	}
> +out:
> +	mutex_unlock(&adapter->fw_lock);
> +	return rc;
> +}
> +
> +static ssize_t acl_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct ibmvnic_acl_buffer *acl_buf;
> +	struct ibmvnic_adapter *adapter;
> +	struct net_device *netdev;
> +	int num_entries;
> +	ssize_t rsize;
> +	int offset;
> +	int rc;
> +	int i;
> +
> +	rsize = 0;
> +	netdev = dev_get_drvdata(dev);
> +	adapter = netdev_priv(netdev);
> +	rc = ibmvnic_get_acls(adapter);
> +	if (rc)
> +		return rc;
> +	acl_buf = adapter->acl_buf;
> +	if (attr == &dev_attr_mac_acl) {
> +		offset = be32_to_cpu(acl_buf->offset_mac_addrs);
> +		num_entries = be32_to_cpu(acl_buf->num_mac_addrs);
> +		if (num_entries == 0)
> +			goto out;
> +		for (i = 0; i < num_entries; i++) {
> +			char *entry = (char *)acl_buf + offset + i * 6;
> +
> +			rsize += scnprintf(buf + rsize, PAGE_SIZE,
> +					   "%pM\n", entry);

Shouldn't the second parameter be 'PAGE_SIZE-rsize' here and

> +		}
> +	} else if (attr == &dev_attr_vlan_acl) {
> +		offset = be32_to_cpu(acl_buf->offset_vlan_ids);
> +		num_entries = be32_to_cpu(acl_buf->num_vlan_ids);
> +		if (num_entries == 0)
> +			goto out;
> +		for (i = 0 ; i < num_entries; i++) {
> +			char *entry = (char *)acl_buf + offset + i * 2;
> +
> +			rsize += scnprintf(buf + rsize, PAGE_SIZE, "%d\n",
> +					   be16_to_cpup((__be16 *)entry));

here?

> +		}
> +	} else if (attr == &dev_attr_pvid) {
> +		u16 pvid, vid;
> +		u8 pri;
> +
> +		pvid = be16_to_cpu(acl_buf->pvid);
> +		vid = pvid & VLAN_VID_MASK;
> +		pri = (pvid & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
> +
> +		rsize = scnprintf(buf, PAGE_SIZE, "%d\n%d\n", vid, pri);
> +	}
> +out:
> +	dma_unmap_single(dev, adapter->acl_buf_token, adapter->acl_buf_sz,
> +			 DMA_FROM_DEVICE);
> +	kfree(adapter->acl_buf);
> +	adapter->acl_buf = NULL;
> +	adapter->acl_buf_token = 0;
> +	adapter->acl_buf_sz = 0;
> +	return rsize;
> +}
> +
>  static DEVICE_ATTR_WO(failover);
> +static DEVICE_ATTR(mac_acl, 0444, acl_show, NULL);
> +static DEVICE_ATTR(vlan_acl, 0444, acl_show, NULL);
> +static DEVICE_ATTR(pvid, 0444, acl_show, NULL);
> 
>  static struct attribute *dev_attrs[] = {
>  	&dev_attr_failover.attr,
> +	&dev_attr_mac_acl.attr,
> +	&dev_attr_vlan_acl.attr,
> +	&dev_attr_pvid.attr,
>  	NULL,
>  };
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
> index e497392..4768626 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -195,12 +195,15 @@ struct ibmvnic_acl_buffer {
>  #define INITIAL_VERSION_IOB 1
>  	u8 mac_acls_restrict;
>  	u8 vlan_acls_restrict;
> -	u8 reserved1[22];
> +	__be16 pvid;
> +	u8 reserved1[52];
> +	__be32 max_mac_addrs;
>  	__be32 num_mac_addrs;
>  	__be32 offset_mac_addrs;
> +	__be32 max_vlan_ids;
>  	__be32 num_vlan_ids;
>  	__be32 offset_vlan_ids;
> -	u8 reserved2[80];
> +	u8 reserved2[40];
>  } __packed __aligned(8);
> 
>  /* descriptors have been changed, how should this be defined?  1? 4? */
> @@ -585,6 +588,19 @@ struct ibmvnic_acl_query {
>  	u8 reserved2[4];
>  } __packed __aligned(8);
> 
> +struct ibmvnic_acl_query_rsp {
> +	u8 first;
> +	u8 cmd;
> +#define ACL_EXISTS      0x8000
> +#define VLAN_ACL_ON     0x4000
> +#define MAC_ACL_ON      0x2000
> +#define PVID_ON	        0x1000
> +	__be16 flags;
> +	u8 reserved[4];
> +	__be32 len;
> +	struct ibmvnic_rc rc;
> +} __packed __aligned(8);
> +
>  struct ibmvnic_tune {
>  	u8 first;
>  	u8 cmd;
> @@ -695,7 +711,7 @@ struct ibmvnic_query_map_rsp {
>  	struct ibmvnic_get_vpd get_vpd;
>  	struct ibmvnic_get_vpd_rsp get_vpd_rsp;
>  	struct ibmvnic_acl_query acl_query;
> -	struct ibmvnic_generic_crq acl_query_rsp;
> +	struct ibmvnic_acl_query_rsp acl_query_rsp;
>  	struct ibmvnic_tune tune;
>  	struct ibmvnic_generic_crq tune_rsp;
>  	struct ibmvnic_request_map request_map;
> @@ -1001,6 +1017,10 @@ struct ibmvnic_adapter {
>  	dma_addr_t login_rsp_buf_token;
>  	int login_rsp_buf_sz;
> 
> +	struct ibmvnic_acl_buffer *acl_buf;
> +	dma_addr_t acl_buf_token;
> +	int acl_buf_sz;
> +
>  	atomic_t running_cap_crqs;
>  	bool wait_capability;
> 
> -- 
> 1.8.3.1
