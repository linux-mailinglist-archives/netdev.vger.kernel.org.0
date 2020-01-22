Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CE7144B75
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 06:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgAVFvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 00:51:35 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:40116 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgAVFve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 00:51:34 -0500
Received: by mail-pf1-f179.google.com with SMTP id q8so2784299pfh.7;
        Tue, 21 Jan 2020 21:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=4/UJ6IfnecXoOAjxwVdDM8sUUls/0gsCWwvcFN3NiHk=;
        b=THv+TzYG3/RgJV0NYNkmfoci0ffFqKSQSvccPH+DnTECr5yJDdBgp17wI3FL44MrEp
         UVEUufWfArD+v2H9ZCPi0HhDAmnLLhkWe8DUH9n6vWC+SkJQ6mPoWo/EwJWXnsCAjeoe
         l/Pkfiii1//l3kXWuzCj1LcaiJvwPZXX0x3SMWkR5THHXNaqsnxT87pCR+URZ4dDeqtL
         RBR3CB6eU7CQdjiP64P8FR8BcGITaYhiNdvwe4SP518HV6j6mrNzXrw5VcXC6BVNszdO
         q0cX/1Nkrf7LdOkEAgNkPcFCq7cKtCdk/XRy566XBOgH+spn+vsIC4G0SxWWH7s/Z252
         bzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=4/UJ6IfnecXoOAjxwVdDM8sUUls/0gsCWwvcFN3NiHk=;
        b=JG43l7C6xM9QYWZUMNzT9xMrlgIaMSmpJ+OoKPLP3Vq5seGyUUKOWaddP7eRQUxDCN
         A0MlnE6biXcf+VDwo44i7/GbBiu1veZ/yjPHudB1K15eb7kY/NQbLk52cFDKDBqpZmDC
         nR3wGqyOh2YzXuvLEBy8p3p7Z4TxnQoY6swBMHzYM9cdt6gVWRw7H167fzbAZgh0V5Yl
         yJID8OdDaO35GVse2XgtUZc5pNZ7OoLx9m8JRYCbQuXe36gApV+i7UkPUBXw1q5dGFfb
         6gUlakjbaj0uF6/UWiUm8SDpWt2exST1w84qxY6baGSg0rnqCMFtRqAOc/rNKA5C/cwp
         IA+w==
X-Gm-Message-State: APjAAAUAsOkJIL6CxdUAFY30oVKQt1HIrcUVn/91aVNzwpT814GsUBcd
        z0b2iGwPrFIYDg0dZETY7NBj/r1WGrSE
X-Google-Smtp-Source: APXvYqz+Qba0iEzCzMfA4cTIHH0fyB7ZyXuW0qwsN0zuiVQXC7vXjFpd00o7OQoMgajydKWN5gomSQ==
X-Received: by 2002:a63:e545:: with SMTP id z5mr9176983pgj.209.1579672293815;
        Tue, 21 Jan 2020 21:51:33 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id a195sm45943554pfa.120.2020.01.21.21.51.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 21:51:33 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH v3] [net]: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Tue, 21 Jan 2020 21:51:32 -0800
Message-Id: <1579672292-21031-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

Kindly let me know if you need any update in this patch from my side. Thanks a lot.

