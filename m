Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8776922362B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGQHsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:48:24 -0400
Received: from mout.web.de ([212.227.15.4]:39509 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGQHsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 03:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594972073;
        bh=+jAVd+UX68jUT+2oR9S7FcHqkLrZpVCaT82gokx+Rcw=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=eCfh26Fc7YnfIZXxupwN8uBbV5BidpnafacVVzUrJWer+6JOGHcxx3tCBSRGKVRs6
         JBQLNHDoWLyRiQ0zf8ImMStnuuABpSATOothCZsTfxg0cnh7PSt8uBuqeoI/uP6Tai
         MLRSJaufL2k0e1LxZraYY41QInSQS8w75URvsN2M=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.15.38]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LzVMw-1ksAXb1exG-014o9T; Fri, 17
 Jul 2020 09:47:53 +0200
To:     Wang Hai <wanghai38@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cuissard <cuissard@marvell.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] nfc: nci: add missed destroy_workqueue in
 nci_register_device
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <26e73d0c-4afb-2c14-d411-6d14c5007419@web.de>
Date:   Fri, 17 Jul 2020 09:47:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SNBOSr3KtQINfvryLfP45T95NQn0FpUadD7LwVjbTXNoFR6UpZj
 dT6XUXyQsIpQ1u/hDUGaWPFbuJKGN7nLcCZfeOadEGvUTricp04QZOB9ofC3Nu41p44PyuA
 UALSvgwR2DcXVUOdGURJk3O/gjnoft3mgkE3qscDwFiHRbX27jutDW1B925FKlL/XBd11Fy
 ghP7U9ZDZJXcRcvp536uA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vqV731jQUJU=:+tV5G3MNwGSp0xi+SQKcZe
 wFEJgI2pDVRwG7XqZLzCAiLYGCjPL6k7fjVDKy8xSqZT5QqI1lMMrarCSo6k2l2GsVeiis0rU
 MgkYzt0/6i2+X4YkyXoL31ncZ0i3se8+dEq2ga63yt7mB/8Hv7nijhDAgbjYTkBmFOFI00puj
 K1G6p8V0Gf4ZCqShVBcZF7TZBqH0DyzK7Le4VSH1Xv1oqcVxHrqUF/IV1007eSWkPgeHLG3hd
 415TM2vTyce1JQTdwAgv9pGKF8+QxnA/jQc7ksX6OQEjK0e3IMyhukpH51JJKWJaifw/UmRTh
 vjW3gv3MEMVYVOUgiQPBVhoTAbpebWXtik8mQXTCnPInTuBHB3jprLpd6RNg+QWaOWX8LTH2f
 1aq6NZ/SJJAvnnvJ/CtZSMgkhZD6GWG109f4VW5NqoRLn7etbdj59Gu9soCzXocNZEmhxPa+V
 rYmLoJ2TyOaIdXejwZhz3k22Gq4UgeLuJNp/fiIO1l5vM+GDSWTlfScDpZEPfUYWGWttwVjlg
 TH4SX5AlaUxT0KDCnhQQSmf4boq9x+X9NPEUXwAJK5bXb192pJGTCUEPd13K09HN85KP1uGqG
 BUa8Z0pHC63ZqW0S38wompMZa0RuFHFMkzXnwDXbuJAkk5kEs67cIJn0Lrmysfd8xN7QkZatL
 P4kEcQ/8BkGdbxojtCCTLW4PgwzDLViygNyOcDTv3CaYSBWQPwgq8Y/qLHmybDFUyAFNBaAot
 ARm2Cnz1+kdSjD3SYHCzFT10C5DNEcvLEu2ZzBpkA5nrIurrE9gQ+YT2KBcO7R76avfPsfXkU
 5cqzEgFs3ZprUH45em+0bzpyVDRAmxU1VRvtqfDcnTzBr6T4letx0dRRsmiaceQDXwxvmr1V+
 t0dIytyLJGRorPk+JNkA3C/mPg1TV+l4wQ2Tnhc6LYj/a3CzzeFT4SgyaOYeEXYZjtzvq9712
 RM1N7gTnuIW8wqwYQvhifeBF8JPpIX+TV1C1LbjCSq23imaUeMPp5NcphdqLAcBHjK61x84yy
 81o7u1R/36SVlPIj+uQ8Al7cI27evS/D7hfvPCOnsCzi48R+9CaFqKd5tqdwcBM+0uN1Mf5T/
 meCLUDzTbkqCpLbb61jL8eY1vNqxdzNaWkd1mm+xGrk3HbA3uk0eqE7W8UOOJ2gX1n9sErtCG
 7YnSqwziM1SLqB6Y2ZwlQRV5pVsywf9B1NFAB95XDbcN4yG8rM62IAN7RRrlGmLB3OLtj1K8i
 rXXX+pBJ05FeYiiOIYWvbXvJ1BqA4ZvEHJDYR0Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When nfc_register_device fails in nci_register_device,
> destroy_workqueue() shouled be called to destroy ndev->tx_wq.

Would an other imperative wording be preferred for the commit message?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3Df8456690ba8eb18ea4714e6855=
4e242a04f65cff#n151


=E2=80=A6
> +++ b/net/nfc/nci/core.c
> @@ -1228,10 +1228,13 @@  int nci_register_device(struct nci_dev *ndev)
>
>  	rc =3D nfc_register_device(ndev->nfc_dev);
>  	if (rc)
> -		goto destroy_rx_wq_exit;
> +		goto destroy_tx_wq_exit;
>
>  	goto exit;
>
> +destroy_tx_wq_exit:
> +	destroy_workqueue(ndev->tx_wq);
=E2=80=A6


How do you think about to use the following source code variant
for this function implementation?

	if (!rc)
		goto exit;

	destroy_workqueue(ndev->tx_wq);


Regards,
Markus
