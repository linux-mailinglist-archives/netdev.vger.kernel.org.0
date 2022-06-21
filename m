Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04130553173
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350232AbiFUL42 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jun 2022 07:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiFUL41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:56:27 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Jun 2022 04:56:25 PDT
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E227B2AE08
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 04:56:25 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2105.outbound.protection.outlook.com [104.47.22.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-GNVNjR2pMLyK5bIZcc74Ug-2; Tue, 21 Jun 2022 13:55:17 +0200
X-MC-Unique: GNVNjR2pMLyK5bIZcc74Ug-2
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0531.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Tue, 21 Jun 2022 11:55:15 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::2879:acb:62c8:4987]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::2879:acb:62c8:4987%8]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 11:55:15 +0000
Date:   Tue, 21 Jun 2022 13:55:14 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     Max Krummenacher <max.oss.09@gmail.com>,
        max.krummenacher@toradex.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] Revert "Bluetooth: core: Fix missing power_on work
 cancel on HCI close"
Message-ID: <20220621115514.GA75773@francesco-nb.int.toradex.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
In-Reply-To: <20220614181706.26513-1-max.oss.09@gmail.com>
X-ClientProxiedBy: ZR0P278CA0068.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::19) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7add516-8c4f-449e-0c08-08da537ce77c
X-MS-TrafficTypeDiagnostic: ZRAP278MB0531:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB05312FB4184E66A0338E42E2E2B39@ZRAP278MB0531.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: iSnkFkgvrmVTX3H5eJLr26AJn3ffHEvAcAQ4cNxnBRUcW/FJfj7uBWLW6K0KYwGOEUi/wU/iVJ0b1mHVfSgDoOe5tod0krwDfRxP3YuDEtqlwZV57uxehysg5KewcbPGKQZ14kL1onCyx5mEX6fFrZgvbE8GIAEoo3tISwPPuqZDwEQ1vvHTt7r+dGDKvCkjGouu/0Zhcs6ZmW9LpeEjLmDKWCv3+ZjDkQf3BGjuv1nvixRZ3MU7tk44WLeSP9HSzyacXXYMuunubQe4cKFUvHKs1GVROURr6auW4OSOn3JCp/4XfP/nkErirybNeJt3eLJNIlZ/bRVY5q09gFkFig1YqHSTWTcKFldMan6zt2CUYy0PfGFzpICJo6QHWYwUkiRhgElFE5V97VygrE3Zlgy5Z/99qMDY+ceVr/RIvUJdpt/WM5ZM/5Xh3tL/C5uRE1rZNr9d3bEbP/YB4yOmYn0GJqaUoJeBK4lV0CA9JrNd2f81QWFsvHl9rrphVALL8tIVw6/wf5+B4kz7cFRBalgluai11RZGctr0ZBYNoHWiqHwlhPxc2NSUC/wKBWXMHbffukVGKHb0z3/dq8QE6bJIb8sWTHS/6prw3B+UhzWnRrNQbpyI8rbp3NzqRzyX6gWIOfhH7aqhib9vDTTZuLXkBu3rToXMw7XKQc8JlvKK+bmGTQDtVi4Gyq/jjC2jUQRA+q4HNGDbCIFTlPov5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(8936002)(33656002)(5660300002)(44832011)(110136005)(7416002)(83380400001)(8676002)(66556008)(66946007)(4326008)(6486002)(2906002)(316002)(1076003)(478600001)(41300700001)(86362001)(6512007)(26005)(38100700002)(186003)(66476007)(52116002)(54906003)(6506007)(38350700002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FcTxS7SZtsCUmfhT8WHHeA8Zi9JHnFNNUZsVXXky8/+Jk1Kn8ZTm/hzd+84J?=
 =?us-ascii?Q?xXS10Vmkp3XIHcO/gHJWKQcXAJt1PeijsL0NVLUA5KR1wtazx9xdz86hoxLQ?=
 =?us-ascii?Q?cFasgN7J15WcPaVdANGOq3BFLOZ2y+afTxywcClkZX7B8je497cbGdlFX2gL?=
 =?us-ascii?Q?fwd3EkSY1aJSj8+4zlSJTOY4gtKvx1qR/CVtzS3vVsG/uzoO3TBB50BioDVx?=
 =?us-ascii?Q?/+C5JNdhOkE6/tkzr1GI7bbKsaTZzpjVGT3EvSwuWJgP/yQg9DAW6ewDwHt7?=
 =?us-ascii?Q?shhUO8fyAiGzccwnBdu2Lxuh4AyXURH+YtRgsQDe0zhiNNFCzg6M77/9RZ+k?=
 =?us-ascii?Q?sPxf0kvdJZjEwhYBYXj0L+mf1AmsQLxh/xtWBD03ybD7NAl5oh/oM24xx8vx?=
 =?us-ascii?Q?vyCC6ozmCPWVYTLEwISJXLdlEQl6KBr6FPTofZcuCSh5pXOEUiFu8Y4nFoB8?=
 =?us-ascii?Q?oxi8hW2Y1gm4TEP5Z7dWuvDp22ZPpB6sjZJ9O2ndGJh3Odv/22MYsa9hfx9Q?=
 =?us-ascii?Q?cDgt1xpQyFaaEQnk/frS+iqldyYSEL41PVOOV6ojNyz0Npi6Kr76Ti9rawVy?=
 =?us-ascii?Q?7dtscRWO2QH9xFwyXBYGr7Jal+Z8glhx6WMEWaDUjzsz6+pOdV9SJ4jpa7/K?=
 =?us-ascii?Q?/9NJ3db09sJZlEXdrg8ffPHCVkKSDzP5MnYo81oJX3bje/N/Rtd2fmUdavOi?=
 =?us-ascii?Q?yW79/E2TrG1BPBnMw0pHEI6ZzOFpX0DWTPqIGF1WW7vSlTYGnVH5rqYut/V7?=
 =?us-ascii?Q?LGVOyl11elFwTLuMSM6/hc+JqcoAqmYdzIaCMLpwm4cj8hHtEDkApO7YgRg7?=
 =?us-ascii?Q?b8ME12PdkTw849W8q7D+8N7QiElnxCqnyA/WxFLfJ7d8ezJT1m8NcigLdAEC?=
 =?us-ascii?Q?34OJUIvhycdkHHLNo169X0OKdEBHswH/2G3f+3gLfBarqL4o2usRvirUcpgT?=
 =?us-ascii?Q?G+hxigGT62+/6uTL1aXtaJAejBkzSlqKIQtMznCG9S+Fur4pMF60asu0eauY?=
 =?us-ascii?Q?+JhkEq44xYqkNOkS8AH3Y6akHnQ1+TqKgWEuLsSiS/wu6jOYMj6356apQFIP?=
 =?us-ascii?Q?F9OF3XbSv6grDOfMkI5iUcNLYZESJWmukU3wnOuwvHEswzw1bUx5LzK/cPf4?=
 =?us-ascii?Q?ZLCi/sn7WejYKUo0S9EMD4IyENQCw040n+BfkiAp+EI48OIrYpoF31BF9yHy?=
 =?us-ascii?Q?E7h38qyArD7xqTovjQUvyglCVQQ6WCRHqlXWziHRpySi/n2j6ndFDH64Yo/D?=
 =?us-ascii?Q?DMZxyiFcziuWnv2D7tgp6MWr8pE47xkddNj2BlxuTT8Ew1Dnnfp+wmZhZKc1?=
 =?us-ascii?Q?5jgeSoGDxQEvs8DuymzO9Aqr/FPMamCkNoCGKGPbtVNUulKhtw6xMNShMyns?=
 =?us-ascii?Q?+q7I/Ax4J0yQkEFsfQ27RWzrcp1onOva8NvBPL1ZEQkn7mO+EzPiKQN0gQ8i?=
 =?us-ascii?Q?6Y+IVCqnTgN9uBC8uQfNGxMlUvQJ6XrftqiNMf1zm0Ek0cW3e7B505aE4OjQ?=
 =?us-ascii?Q?SJjpY2R7okcCcmvMMqkfTYcOzzuCmyjMFyjqbYBChZJ6Ewt8a4OEs9nbMtkq?=
 =?us-ascii?Q?jCBPuIL1APwgyG9mkXXT25DKf1ySXdbbDkqZJK09ZP9Miuxhx7soVuOyaX7M?=
 =?us-ascii?Q?IqePu6rCPYNit6hEfbiVFg/qCUD17gVo+Is36+NZLdBcAtK9hYdQPFJAWqVL?=
 =?us-ascii?Q?whi1QqP9O5f+Mf+geVXCntjrpLRPKaobWhiQsgeXqCOq4wZ/0dgoRS7KE0eF?=
 =?us-ascii?Q?0EXDPt6tT3jhmtQI2/CizMisJQwtJcYUMsn9KXkRJINSPVhDOH+N?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7add516-8c4f-449e-0c08-08da537ce77c
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 11:55:15.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jw/h/3T2s0U/yzS5IX4nRYviwZdm+pwDtsiwYt+PMyey7lTdVAPHOmQ1UboHr6L+VuYeUVX5o0uS8cw731pZrBBg7RigHrNFa4qt2o3TXj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0531
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcel, Vasyl,
any comment on this?

Francesco

On Tue, Jun 14, 2022 at 08:17:06PM +0200, Max Krummenacher wrote:
> From: Max Krummenacher <max.krummenacher@toradex.com>
> 
> This reverts commit ff7f2926114d3a50f5ffe461a9bce8d761748da5.
> 
> The commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work
> cancel on HCI close") introduced between v5.18 and v5.19-rc1 makes
> going to suspend freeze. v5.19-rc2 is equally affected.
> 
> This has been seen on a Colibri iMX6ULL WB which has a Marvell 8997
> based WiFi / Bluetooth module connected over SDIO.
> 
> With 'v5.18' or 'v5.19-rc1 with said commit reverted' a suspend/resume
> cycle looks as follows and the device is functional after the resume:
> 
> root@imx6ull:~# rfkill
> ID TYPE      DEVICE    SOFT      HARD
>  0 bluetooth hci0   blocked unblocked
>  1 wlan      phy0   blocked unblocked
> root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
> root@imx6ull:~# date;echo mem > /sys/power/state;date
> Tue Jun 14 14:43:03 UTC 2022
> [ 6393.464497] PM: suspend entry (deep)
> [ 6393.529398] Filesystems sync: 0.064 seconds
> [ 6393.594006] Freezing user space processes ... (elapsed 0.015 seconds) done.
> [ 6393.610266] OOM killer disabled.
> [ 6393.610285] Freezing remaining freezable tasks ... (elapsed 0.013 seconds) done.
> [ 6393.623727] printk: Suspending console(s) (use no_console_suspend to debug)
> 
> ~~ suspended until console initiates the resume
> 
> [ 6394.023552] fec 20b4000.ethernet eth0: Link is Down
> [ 6394.049902] PM: suspend devices took 0.300 seconds
> [ 6394.091654] Disabling non-boot CPUs ...
> [ 6394.565896] PM: resume devices took 0.440 seconds
> [ 6394.681350] OOM killer enabled.
> [ 6394.681369] Restarting tasks ... done.
> [ 6394.741157] random: crng reseeded on system resumption
> [ 6394.813135] PM: suspend exit
> Tue Jun 14 14:43:11 UTC 2022
> [ 6396.403873] fec 20b4000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> [ 6396.404347] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> root@imx6ull:~#
> 
> With 'v5.19-rc1' suspend freezes in the suspend phase, i.e. power
> consumption is not lowered and no wakeup source initiates a wakup.
> 
> root@imx6ull:~# rfkill
> ID TYPE      DEVICE    SOFT      HARD
>  0 bluetooth hci0   blocked unblocked
>  1 wlan      phy0   blocked unblocked
> root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
> root@imx6ull:~# date;echo mem > /sys/power/state;date
> Tue Jun 14 12:40:38 UTC 2022
> [  122.476333] PM: suspend entry (deep)
> [  122.556012] Filesystems sync: 0.079 seconds
> 
> ~~ no further kernel output
> 
> If one first unbinds the bluetooth device driver, suspend / resume works
> as expected also with 'v5.19-rc1':
> 
> root@imx6ull:~# echo mmc1:0001:2 > /sys/bus/sdio/drivers/btmrvl_sdio/unbind
> root@imx6ull:~# rfkill
> ID TYPE DEVICE    SOFT      HARD
>  1 wlan phy0   blocked unblocked
> root@imx6ull:~# echo enabled > /sys/class/tty/ttymxc0/power/wakeup
> root@imx6ull:~# date;echo mem > /sys/power/state;date
> Tue Jun 14 14:59:26 UTC 2022
> [  123.530310] PM: suspend entry (deep)
> [  123.595432] Filesystems sync: 0.064 seconds
> [  123.672478] Freezing user space processes ... (elapsed 0.028 seconds) done.
> [  123.701848] OOM killer disabled.
> [  123.701869] Freezing remaining freezable tasks ... (elapsed 0.007 seconds) done.
> [  123.709993] printk: Suspending console(s) (use no_console_suspend to debug)
> [  124.097772] fec 20b4000.ethernet eth0: Link is Down
> [  124.124795] PM: suspend devices took 0.280 seconds
> [  124.165893] Disabling non-boot CPUs ...
> [  124.632959] PM: resume devices took 0.430 seconds
> [  124.750164] OOM killer enabled.
> [  124.750187] Restarting tasks ... done.
> [  124.827899] random: crng reseeded on system resumption
> [  124.923183] PM: suspend exit
> Tue Jun 14 14:59:31 UTC 2022
> [  127.520321] fec 20b4000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> [  127.520514] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> root@imx6ull:~#
> 
> Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
> 
> ---
> 
>  net/bluetooth/hci_core.c | 2 ++
>  net/bluetooth/hci_sync.c | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 59a5c1341c26..19df3905c5f8 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2675,6 +2675,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
>  	list_del(&hdev->list);
>  	write_unlock(&hci_dev_list_lock);
>  
> +	cancel_work_sync(&hdev->power_on);
> +
>  	hci_cmd_sync_clear(hdev);
>  
>  	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 286d6767f017..1739e8cb3291 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4088,7 +4088,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>  
>  	bt_dev_dbg(hdev, "");
>  
> -	cancel_work_sync(&hdev->power_on);
>  	cancel_delayed_work(&hdev->power_off);
>  	cancel_delayed_work(&hdev->ncmd_timer);
>  
> -- 
> 2.20.1
> 

