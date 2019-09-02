Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2EDA5BCC
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 19:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfIBRYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 13:24:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbfIBRYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 13:24:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x82HLlp6077030;
        Mon, 2 Sep 2019 13:24:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2us5eeukwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Sep 2019 13:24:43 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x82HMi3q078694;
        Mon, 2 Sep 2019 13:24:43 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2us5eeukwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Sep 2019 13:24:43 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x82HKDnh020803;
        Mon, 2 Sep 2019 17:24:42 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2uqgh6gxs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Sep 2019 17:24:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x82HOf2n40960420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Sep 2019 17:24:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5609DAE06B;
        Mon,  2 Sep 2019 17:24:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 810B4AE05C;
        Mon,  2 Sep 2019 17:24:39 +0000 (GMT)
Received: from kashyyyk (unknown [9.85.146.12])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon,  2 Sep 2019 17:24:39 +0000 (GMT)
Date:   Mon, 2 Sep 2019 14:24:33 -0300
From:   Mauro Rodrigues <maurosr@linux.vnet.ibm.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 11/15] i40e: Implement debug macro hw_dbg using
 pr_debug
Message-ID: <20190902172433.GA8007@kashyyyk>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
 <20190828064407.30168-12-jeffrey.t.kirsher@intel.com>
 <20190828153936.57ababbc@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828153936.57ababbc@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-02_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909020196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 03:39:53PM -0700, Jakub Kicinski wrote:
> On Tue, 27 Aug 2019 23:44:03 -0700, Jeff Kirsher wrote:
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> > index a07574bff550..c0c9ce3eab23 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> > @@ -18,7 +18,12 @@
> >   * actual OS primitives
> >   */
> >  
> > -#define hw_dbg(hw, S, A...)	do {} while (0)
> > +#define hw_dbg(hw, S, A...)							\
> > +do {										\
> > +	int domain = pci_domain_nr(((struct i40e_pf *)(hw)->back)->pdev->bus);	\
> > +	pr_debug("i40e %04x:%02x:%02x.%x " S, domain, (hw)->bus.bus_id,		\
> > +		 (hw)->bus.device, (hw)->bus.func, ## A);			\
> 
> This looks like open coded dev_dbg() / dev_namie(), why?

Indeed, thanks for pointing out. I'll fix this and the other patch you
reviewed and resubmit.

I'm not sure what should be the preferred approach here though, just use
dev_dbg to implement this macro or replace all of its occurrence in the
code by dev_dbg?

Jeff, do you have any preference?
> 
> > +} while (0)
