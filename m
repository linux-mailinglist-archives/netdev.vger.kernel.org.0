Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC8A4041
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfH3WQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:16:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40248 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728178AbfH3WQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:16:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so4197054pgj.7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LRF6fDFJ507MB4WsV37u1mb9nD9YR26q2TMuQyhEIu0=;
        b=mxPtZlF118dZzKOJCpL3OKNrhgJ7Wk+NWXJp3YqoLXU/DiBv9cfa8S52PPKYjBto5G
         lldCVhke9JqYN9oyxl8oc4GHj03pQoGWFs/jWeS2MslJXl/zDilpI4OmABqLNJplOjxu
         huJ9oO3X6Bq++LKq3Ey563XuPXaUaRlJfL2hgqsKK/YKaWvGQAyy4IJ4PhoPwHkulPNK
         Me18MUtHIFf9Wt4fJbDY7QL3HzD9RAGUPYGwWdt+fFnY5W84v2IiKBxVRvhTpW4DD+9o
         mDfEHohqHCe04/dtRHnM0DAX5RU0skbLAvcY4VNKzxw2D2kzYna4YH7q4D0THehSbl3d
         L9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LRF6fDFJ507MB4WsV37u1mb9nD9YR26q2TMuQyhEIu0=;
        b=OlYYjRIWjzh9kazum3+v3CXKBBmGvfSJ+RaZ/L8jtU9rizqUFm3otMN2nnu1jjKtLJ
         fc3/7A5EUsux3k0HMmRYlKnDaqWJMWjJu8w52AMvjkWEG5C6K4T7p/CJZ88VvDsAyc08
         /mtXZVjXsVD+SX8I5hw58Ib4wOK96qeJfzy+xdImvaWmtLvWNljeV7qLFBM4E1u+Kt+4
         lKSNP5a9K0ecpVbI73Xgfrxj31RMHTJvO71+/+IDzk/VXzqVkZ6StjIpMga1AkMiYM0s
         +RDvVeti3ocOpIc57Mz1R0RPqGqbqD621ITFdqt3D5WC1gOVqplBDcyPHA/jBlFK0g7O
         CfdQ==
X-Gm-Message-State: APjAAAWsKcNd0nVl+4H8cmR6utBARdaXy1w8HavcEoIxeGU5HexkvaeI
        hFrZjdswK8Pjqf5smd91rkPcvQ==
X-Google-Smtp-Source: APXvYqwmN/tsZlThDHAlJ8Ad4AGaIp5f1y40Zdu+l02abEgN2qTTZjZs3Z3HEzcu9Y8ujSF2SvSZtg==
X-Received: by 2002:aa7:8498:: with SMTP id u24mr20998169pfn.61.1567203387813;
        Fri, 30 Aug 2019 15:16:27 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n185sm5606050pga.16.2019.08.30.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:16:27 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:16:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
Message-ID: <20190830151604.1a7dd276@cakuba.netronome.com>
In-Reply-To: <bad39320-8e67-e280-5e35-612cbdc49b6f@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-8-snelson@pensando.io>
        <20190829155251.3b2d86c7@cakuba.netronome.com>
        <bad39320-8e67-e280-5e35-612cbdc49b6f@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 12:31:07 -0700, Shannon Nelson wrote:
> On 8/29/19 3:52 PM, Jakub Kicinski wrote:
> > On Thu, 29 Aug 2019 11:27:08 -0700, Shannon Nelson wrote: =20
> >> +static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_=
qcq *qcq)
> >> +{
> >> +	struct ionic_dev *idev =3D &lif->ionic->idev;
> >> +	struct device *dev =3D lif->ionic->dev;
> >> +
> >> +	if (!qcq)
> >> +		return;
> >> +
> >> +	ionic_debugfs_del_qcq(qcq);
> >> +
> >> +	if (!(qcq->flags & IONIC_QCQ_F_INITED))
> >> +		return;
> >> +
> >> +	if (qcq->flags & IONIC_QCQ_F_INTR) {
> >> +		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
> >> +				IONIC_INTR_MASK_SET);
> >> +		synchronize_irq(qcq->intr.vector);
> >> +		devm_free_irq(dev, qcq->intr.vector, &qcq->napi); =20
> > Doesn't free_irq() basically imply synchronize_irq()? =20
>=20
> The synchronize_irq() waits for any threaded handlers to finish, while=20
> free_irq() only waits for HW handling.=C2=A0 This helps makes sure we don=
't=20
> have anything still running before we remove resources.

mm.. I'm no IRQ expert but it strikes me as surprising as that'd mean
every single driver would always have to run synchronize_irq() on
module exit, no?

I see there is a kthread_stop() in __free_irq(), you sure it doesn't
wait for threaded IRQs?
