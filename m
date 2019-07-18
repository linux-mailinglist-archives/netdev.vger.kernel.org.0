Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051C66C417
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 03:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfGRBV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 21:21:58 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:24765 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfGRBV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 21:21:58 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2019 21:21:57 EDT
Received: from smtp.aristanetworks.com (localhost [127.0.0.1])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 81F6141F4DD;
        Wed, 17 Jul 2019 18:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1563412567;
        bh=XQfG/VA7xJfNYzDYRini/Q22wPI0n6BY6yu5CeOZ7I8=;
        h=Date:From:To:Cc:Subject;
        b=mAL03nel2Z4Q8zuTCRTGqh7WLWiIXenc7+I2GjwXP+9pSdNZubrjpTabldwX7ogub
         +hsTuY87zYsbry2rShnYbFgSHLJ4PCvLrLwtLVoW0YtBipDci8PRnxK4qdDXM1jAiQ
         x4n1H45DrwsAJdveZdcRP3cxt2aMXx5FJ/D7FUt+47PQlIXXUEgzqCnnIUTIw/TRhr
         Jmd0Wo/ae+6bSL+qsqNxCQ2eCRthIlD/I0OaSj8lVrDsmc3wz6EhDQILzZyG5OV3qq
         muUQcdQUHEroHymTs7RUQPOFwAfSiJGTc9KxB8lSEFSdqeV3V6UIW2d6L0sCpc+GCq
         dpT/urQmufcLQ==
Received: from visor (unknown [172.20.208.17])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 76335419895;
        Wed, 17 Jul 2019 18:16:07 -0700 (PDT)
Date:   Wed, 17 Jul 2019 18:15:31 -0700
From:   Ivan Delalande <colona@arista.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] json: fix backslash escape typo in jsonw_puts
Message-ID: <20190718011531.GA29129@visor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: fcc16c22 ("provide common json output formatter")
Signed-off-by: Ivan Delalande <colona@arista.com>
---
 lib/json_writer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/json_writer.c b/lib/json_writer.c
index 5004c181..88c5eb88 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -75,7 +75,7 @@ static void jsonw_puts(json_writer_t *self, const char *str)
 			fputs("\\b", self->out);
 			break;
 		case '\\':
-			fputs("\\n", self->out);
+			fputs("\\\\", self->out);
 			break;
 		case '"':
 			fputs("\\\"", self->out);
-- 
2.22.0
