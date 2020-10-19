Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53F292243
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 07:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgJSFnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 01:43:17 -0400
Received: from mail-vi1eur05on2120.outbound.protection.outlook.com ([40.107.21.120]:32864
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgJSFnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 01:43:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACGRJZRFwGkSb8Ua2ukqNn9+G4lRKCizymqcF8cAsh9k/Mlt/CSxLSCLrkMUn5dzPGfjoQrJDgs0knm2ek7zC2oeVwBw9uWU3IkR57CO73kLaWnGFvJCTF8nL6WaDa5HUkiuMBaE7ZF0jxYKc4+ugR48rwsjicXnikUcw/abLwhC6oq6VwaxDlP4AbLRZ5i6ryMoNk50cCCTLS3qXDXkzJeJE3YzxOWNeQyMHf32EqQF8h6Ioi7bbjQWVXP3efDbEoNMqeX7+nUHxTmwm8B978tJ/Olh/OWi3Bs3d3ceD95cgFDhCPA0whv6WpB2KhoRrSWZQPg6WgJN0qozWqy5Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fn/B+6qClhlBPXAcecN6lTr+8ITwB9lPwE+1ADa8d5k=;
 b=DxXe1IMLqukElwibKMS9lROQzjkGWocTN83C+vR1RRyddLaT2hLOfYQdp9SlSHFegScq/x1x8sBnTQ0M4U1yn3INa+0DTEEbFLfC0iNDMcN0eHxJxcgBS22N091rwakobClDXbnR6oPqGJhbBK+Hb4+20e+E0bOJQzgqVjhffWUqK4JNqqSzYHDd5rsFvmomugGozDR5+NEW/L5avZ3V+MXAhOTjr5CYGS31IIhySzozKnnnsBPv6dsHuAZK4ZdO1nzQ4PID2/xz6K0Wf80WNqAhgAqbO9nxzSdXNev6LfXcwCpKYcZyh6tEMBc0OEz1UPKKmzskPkx9WtcMhQ/f8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fn/B+6qClhlBPXAcecN6lTr+8ITwB9lPwE+1ADa8d5k=;
 b=DmgH73oXTm13UTYi3rBIKvYvPIu9SKU+RxfdFaBM+y1xsqBD7gzF9oJy5f0/dGbysBew0P1BEfPfkpD8ZxXsdBJ7X3iX1oXi6I+bJ6R2mFCLAXDDlkpWv7Y66Xhc0lmw2Biujq7NIHX8TnH7vG8zZCqASEGm2ZfhhTr5+ftWwEk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB5364.eurprd05.prod.outlook.com (2603:10a6:208:f8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 19 Oct
 2020 05:43:12 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 05:43:12 +0000
Date:   Mon, 19 Oct 2020 07:43:10 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH v2 0/6] igb: xdp patches followup
Message-ID: <20201019054310.uwy4whq2eizvdolz@SvensMacBookAir-2.local>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
 <20201018133951.GB34104@ranger.igk.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018133951.GB34104@ranger.igk.intel.com>
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM4PR07CA0009.eurprd07.prod.outlook.com
 (2603:10a6:205:1::22) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir-2.local (109.193.235.168) by AM4PR07CA0009.eurprd07.prod.outlook.com (2603:10a6:205:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.11 via Frontend Transport; Mon, 19 Oct 2020 05:43:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef1ce936-b474-4c97-1074-08d873f1dda2
X-MS-TrafficTypeDiagnostic: AM0PR05MB5364:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5364C6C1241699DC296E460BEF1E0@AM0PR05MB5364.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyxB3y8K+qMxm4W74atUYo3mfDmUPAexre3QyyifjOcMmbg9IEPwSGdjtlbwBVjGEHh+uQgTB6BhOMdkw43OzMFsvbCrJtBF5EoW5lFGZsIdIDXGj7xgfccfMFnfFCw2wijhYK7M1heL5RXu/vjCLD6ZZqGin/O2Q4N2LykifsshLv0r2dP+paGmxbOAaIRR0epWIvzFOqtpDKV1ZjE0875UXggfKMd+05FWuqd9/MNlxYRIWzzS05s1AEOVGoeppi9f76+/CjGaITpDW1I6Xgg5UdXhSi8bxDJvHUJXgA14gYVs9J5pZlMTCIH1HKRlF0p2nso45J36wnDDs4/j2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39830400003)(136003)(366004)(376002)(396003)(316002)(478600001)(6506007)(5660300002)(44832011)(956004)(26005)(86362001)(83380400001)(1076003)(66476007)(66556008)(2906002)(7696005)(52116002)(8676002)(55016002)(66946007)(16526019)(186003)(9686003)(6916009)(4326008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IrWW0EXIvnLb+EaoWNOei+ExqJPlm47AtDnHVTo9OAUpqkEGRRBb+nWdNTyCqMUfpFnBU7MAKoGt1+WgI5sXO56Kmv/w9hlz68uIOikpv9c0EplHs0XFJ/a252b8xYtxEzGW909oGJ8VfIX3tUpTLQVl13jGERhdxMtyURbO/ai5dYIxXHGnzlWvnXl7SnFsV3qZLI00nX0lrnelpN+FX8xD6hCqeBgocOvSaBDIYEiJ+kfvztma+IvDvKB89hhqcAQBxm864zSmc6iWg3DPAJu3x2R+TWy6v8ZQv9GBhfljNJYNoOR5JTivkOPTW5D25LmtiB6DjipgIioRQu1fawyNS4aXCpEd/qcpTvNd1tanE5i7cpH8BBx0wFEP3Ws0iXH33E8Uf2y+5jap9AgL1Y9d/3MjLAHO0ry87UYujvP2OQeVRAhaRgd4oHBasYeJTm/26yfFGMB87Jool0asJNXRwH0mQ27uF8FSJ2/mF0nLpXd1zZJjW8goWXGQWTgJrerPpFGt4NpHJOWWMiSmQ5ny0Mx2wlacAMm2s9I2CkPJlKVMfj7DvvOlL54TTFAFWlyqwyQgRLijgqRqkac6wRQoTy4kwBE+5w6cengJN5GDwKTsAt/NdWAga18q6RQiB6+D4yG5b4lTiBwsPMmIcQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1ce936-b474-4c97-1074-08d873f1dda2
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 05:43:12.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbJtv1iO3rjMmgRpsAfoULBqruwCIQmUVSMdlYp79P3udBw8e15J7KHr2lqz45epFsFI7DrGptTZAWE7q+gCNrilIFqdv6bSHdGek9gw5AM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 03:39:51PM +0200, Maciej Fijalkowski wrote:
> On Sat, Oct 17, 2020 at 09:12:32AM +0200, sven.auhagen@voleatech.de wrote:
> > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > This patch series addresses some of the comments that came back
> > after the igb XDP patch was accepted.
> > Most of it is code cleanup.
> > The last patch contains a fix for a tx queue timeout
> > that can occur when using xdp.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Sorry for not getting back at v1 discussion, I took some time off.
> 
> For the series:
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Couple nits:
> - you don't need SOB line within cover letter, I suppose
> - next time please specify the tree in the subject that you're targetting
>   this set to land; is it net or net-next? net-next is currently closed so
>   you probably would have to come back with this once it will be open
>   again
> - SOB line should be at the end of tags within commit message of patch;
>   I'm saying 'should' because I'm not sure if it's hard requirement.

Thank you, I will fix that and send a v3.

Best
Sven

> 
> > 
> > Change from v1:
> >     * Drop patch 5 as the igb_rx_frame_truesize won't match
> >     * Fix typo in comment
> >     * Add Suggested-by and Reviewed-by tags
> >     * Add how to avoid transmit queue timeout in xdp path
> >       is fixed in the commit message
> > 
> > Sven Auhagen (6):
> >   igb: XDP xmit back fix error code
> >   igb: take vlan double header into account
> >   igb: XDP extack message on error
> >   igb: skb add metasize for xdp
> >   igb: use xdp_do_flush
> >   igb: avoid transmit queue timeout in xdp path
> > 
> >  drivers/net/ethernet/intel/igb/igb.h      |  5 ++++
> >  drivers/net/ethernet/intel/igb/igb_main.c | 32 +++++++++++++++--------
> >  2 files changed, 26 insertions(+), 11 deletions(-)
> > 
> > -- 
> > 2.20.1
> > 
