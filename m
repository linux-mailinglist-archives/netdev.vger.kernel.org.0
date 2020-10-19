Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF0D292245
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 07:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgJSFnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 01:43:50 -0400
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:40391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgJSFnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 01:43:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldUEtBpZzrpyAriTERSvXMILFIFj009fdDkKA3S3I7wvmkQv8J2ACR8zHmdIzOPIFn0Z7eOltW4Gi0VTgZYP2YR0+b4WTOm4K02To/6jtO54lAjBAMZzUd2tv2SOTWLVEW+ewE5r6DGJcti3UxUye5zCr7ita8yUuznQF/hnvZrIywDpUupaHb1YH7+q87fOMY8BxF/Mg9QzUYuNORn1HNp3Yo4RIPFtmPKzHFrkg5ixbw2WbPZ/I3HBCiEZGV1gstXN5C1oQOVSKGjO91Fzn1hhNr27Q08nSTuWqbtcFxSlJoYv6HlfPaR1LXjJy7rVO5/74QClk4zqN6cAu60uaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+I9idjkmv+21szPzuHkB0K7MMMDnLTIwTqyXT2NIiE=;
 b=TmX8wckbYv0/BhvQT/04Csoa+QWkJ8brBH/iazAZ0SKs4GWyPZDGHG7u3je7f3Mb46KrCBQM/h/d9nU3CILfq0R+n6otzjEyDcmsHL1LErLooJbv1h8uADZDHywPRhu5uhz6HN78xS9UhqBh0lsAoZi9p17laVSlArbFcLWE6BKqE5HxsPqWz6PprBwtRnBsenJFv6F7hGSh4+/rotc5cQl5EwQDriTnIuklbrhvPme7HSQ8tsKp9blQw3k46Q8JSX28H6QjMLZhGuXcFfP8vuanilM1UfPhvVbpfS05q9xoyTPJcWS29LUGAUbCy8p+B8B7k78iOIvIPX9GTTeK5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+I9idjkmv+21szPzuHkB0K7MMMDnLTIwTqyXT2NIiE=;
 b=GF4wpg+UBWuhtVgXt/sUPxS25DfnaloED8AFp3Y5z19A1alDAXS+nA72PWKrY+7JFUypwMz8z1zFHQ84aCeMhXKfjSIp6u9RkRfAKTAb2CYN69e/OyexXIjv+V1hxYak5hxj2AhzPCVrdNHVBbPp1OftInoK4F9CaUAH8ypHEq4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM4PR0501MB2723.eurprd05.prod.outlook.com (2603:10a6:200:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Mon, 19 Oct
 2020 05:43:45 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 05:43:45 +0000
Date:   Mon, 19 Oct 2020 07:43:44 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH v2 0/6] igb: xdp patches followup
Message-ID: <20201019054344.ei3yp2d7fqobgd6q@SvensMacBookAir-2.local>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
 <20201018133951.GB34104@ranger.igk.intel.com>
 <20201018120336.4a662b4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018120336.4a662b4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR06CA0115.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::20) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir-2.local (109.193.235.168) by AM0PR06CA0115.eurprd06.prod.outlook.com (2603:10a6:208:ab::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 05:43:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f00e45c-2e5f-4cf0-5383-08d873f1f1a2
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2723:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2723E3D56C52A1B6A59DA5B1EF1E0@AM4PR0501MB2723.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y3b4tB4gXcE0xGJZ4cidla9JvH/i5Zvlt5czL4Rw8MRbYyNVlmwg4rpGkuASv6Nbq9q2uAvpkYcnblv0PSZi6R/cwYG5rkD7fOfJPnvgjIPXTrvkxD/8PmCXx2f7xGjNHmOJg8vbdn9sE9sQMTfhKYhpbnwXsQsJbIe484W6E46r0jve7NuLqQQhtHg2SnuF7Deg0u8ZqAhPTWmQ0w8yG6NJKr0+B0013i2TvZydm30w7eiZRae2PNHV9vvbu+QpRUl4SxuVs/EgpntP9/U2xJWyzsBdnM1rRvwOMlKtoy7FhNmGuojbQx6PB8rDWSUR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(39830400003)(376002)(66946007)(5660300002)(2906002)(4744005)(52116002)(7416002)(956004)(6506007)(66476007)(55016002)(7696005)(316002)(16526019)(8936002)(86362001)(6916009)(44832011)(8676002)(66556008)(26005)(4326008)(1076003)(83380400001)(186003)(478600001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EfBrY4BW3cuw+SbmLkrJVEViFtIlJwzEt+Ap3jSeoDXnx2O9asL3ITguuBQiPhU48Qn6ryni+au4+WeILqvlrxkJ2WPZw7HXAOiBEl6UwcuE6l2u+akX5uHqbBjhCSj9uPBNRQ+7W5Bm0f+axOjtLW1elNV5vvt1sgVHICpKK4bL+yNFnA+uxjX6FpqvTFAsXl6wVM54yW7sbc6QO/hkMSayXnBrNuLDClclqDFiEKEuKwpKUccfWzyk24ZmauslISlql0FTa0EpXkKruQCHdYvxMkH60+IS8Oqtj8TDGhLrzmDlrfdJXey/88XgltFe0gLVoUVZOuIr1icdWvxg7W5x/NvU2oUhkbgiTDfnJu91r8qNg3TcfAkE77/STguuAQc/JwptIybEuepnLG9XFJvIRfxE8cfcDRsHVDouZQFBfqTIsCkZahw3sysbbV0xf/9JVjDtfl5ky5hxencK/pH2LJmrkkfCEeLaMmwGoghEcpNTzc4K1mrzl50ahiBUEhtOW+MmLR8MYuV4gAjkdx0JxGt0D+Qx9FWb60QCFFkgH8hXUIBaodagYgdPauUOxblDQTY9VhbOjFnggUuMR7PPHU5G2dKu4nhoH/Z2WEUvrlZMGn2eyhmZ3TB4toXMN0MiE8T7Gla8ESoy7EE3wQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f00e45c-2e5f-4cf0-5383-08d873f1f1a2
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 05:43:45.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pexsxA/ZLUYjUrdvJfjMW4kqX8PGp0l63OVR//DOOHqGJzZUZLCIyGN9RW2cqXSX0eDpRyF3OdXxw1GR3xeJ7xNPHq0zCnryGtY1f4NTJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2723
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:03:36PM -0700, Jakub Kicinski wrote:
> On Sun, 18 Oct 2020 15:39:51 +0200 Maciej Fijalkowski wrote:
> > - next time please specify the tree in the subject that you're targetting
> >   this set to land; is it net or net-next? net-next is currently closed so
> >   you probably would have to come back with this once it will be open
> >   again
> 
> Most of the patches here look like fixes, so we can take them into net
> but please repost them rather soon.

I will repost them today.

Best
Sven

