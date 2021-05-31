Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD039586B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhEaJty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:49:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230520AbhEaJtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 05:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622454473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J3BTo8t81aylp90gddYFNRcd2rHaMywQEjhk9CSK0/s=;
        b=ifHIeQK2QZybyoV/Ke/TIMOTKFmh1iSqQIVIMh0c5kwLO2VX3qaZBR96EB5nvcLfWIlOT/
        vnWEGdBm22ZZ46kvoqkohKQ/83zvYUo4AkV1pz3u/DGiUhvWbqXBCW1yIwM/AufA1bB7Ls
        TJBh59pbmN9WOzq/oz1hr0ZfmlwBVUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-rApkTaNKOOO1Omqs_EJNlg-1; Mon, 31 May 2021 05:47:50 -0400
X-MC-Unique: rApkTaNKOOO1Omqs_EJNlg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E06180FD69;
        Mon, 31 May 2021 09:47:48 +0000 (UTC)
Received: from Leo-laptop-t470s.redhat.com (ovpn-12-207.pek2.redhat.com [10.72.12.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 314C45DEAD;
        Mon, 31 May 2021 09:47:46 +0000 (UTC)
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Hangbin Liu <haliu@redhat.com>
Subject: [PATCH iproute2-next 0/2] configure: convert global env to command-line options
Date:   Mon, 31 May 2021 17:47:38 +0800
Message-Id: <20210531094740.2483122-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This path set converts the global environment to command-line options
to make it easier for users to learn or remember the config options.

I only convert environment INCLUDE, LIBBPF_DIR, LIBBPF_FORCE at first.
The IPTC and IPTL are not converted as I don't know what they stand for.

Hangbin Liu (2):
  configure: add options ability
  configure: convert LIBBPF environment variables to command-line
    options

 configure | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

-- 
2.26.3

