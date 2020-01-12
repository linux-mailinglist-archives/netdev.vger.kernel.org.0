Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97354138B9F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 07:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgAMGHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 01:07:08 -0500
Received: from mail02.vodafone.es ([217.130.24.81]:64817 "EHLO
        mail02.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAMGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 01:07:08 -0500
IronPort-SDR: RAcoesv2srCW+pT0aJ/ogThrgPR8f5B6emgjFLWiw/H6YFKwYOsOOIdXKyWpamd4b5nZs5iX/7
 I/XbgVpbj4gg==
IronPort-PHdr: =?us-ascii?q?9a23=3ADXP2CBM4xt9D4k5GjiYl6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0IvvzrarrMEGX3/hxlliBBdydt6sfzbCI4uuxAyQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagb75+Ngu6oATVu8UZhYZuNLs6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gysBMDI37X3YhdZ1jKNbuR6suRt/w5TMYIGSLvpxZL/dcs0DSW?=
 =?us-ascii?q?VfWMZdTjBMAp+gb4QVE+UBPfhXr4zjqFsIsRuyHBejBOX2xjFPgX/227M10u?=
 =?us-ascii?q?Q4HQ7Y2gwrAtYCvXrIoNnpMasfV/2+wqvVwjXZd/5Y1zfz6JLWfB4ivP+DUq?=
 =?us-ascii?q?5/f8XKxEkzFQ7KkkmcpZD5Mz+L0OkGrmiV7/BnVeKqk2MpsR9+oiSxycc2l4?=
 =?us-ascii?q?LGhoUVylbL9S5kx4s1PcO3SFJlbt6+HppQsCeaN4RtT8MiWGFnozo1xqcatp?=
 =?us-ascii?q?68eSgG0pQnxx3GZvGBboOG4QrjWf6PLTtlhn9pYq+zihiu/US61OHxWdO43V?=
 =?us-ascii?q?hKoydDj9LCrGoC1wbJ5ciCUvZ9+0Ch1iuR2A3L8eFEJFw0lbLcK5483r48jp?=
 =?us-ascii?q?oTvlrHHi/xgEj2ibWZdkQg+uiy9evnZqnqq5CGO49qjQHxL74hmsK4AeQ+LA?=
 =?us-ascii?q?cCRXaU+f+k2L3i+032XqlKg+UonqXEsp3WP9kXq6ClDwNPzIou5AyzAjmm3d?=
 =?us-ascii?q?gAmHkINlNFeBaJj4jzPFHOJej1De+hjFSwjjhr3f7HPrrnApXCNXXDkKzhcq?=
 =?us-ascii?q?1h5EJG1AUzytVf64hUCrECOP7zQFP+tMTEDh8lNAy52+DnB8th1owDR22PHL?=
 =?us-ascii?q?SUML3dsVCW/OIjOeqMa5EPuDb7Nfcl4+TijXgjmV8SLuGV2s4RZWy0E+pOPU?=
 =?us-ascii?q?qUezzvj80HHGNMuRAxH9bnkFmTbTkGX3uuUrh02TY9B8ryFYrfS5qyh7qO3C?=
 =?us-ascii?q?S7BZddTm9DA1GIV3zvctPXde0LbXeqL9NsiHQ7Ur6uA9s52A2jrhD9zbVPLv?=
 =?us-ascii?q?He8WsTspel1NsjtL6brg076TEhVpfV6GqKVWwhxTtQSg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2GbIwCpBxxemCMYgtlNGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBewIBGAEBgS6BTVIgEpNPgU0fg0OLY4EAgx4?=
 =?us-ascii?q?VhggTDIFbDQEBAQEBNQIBAYRATgEXgQ8kOgQNAgMNAQEFAQEBAQEFBAEBAhA?=
 =?us-ascii?q?BAQEBAQYNCwYphUqCHQweAQQBAQEBAwMDAQEMAYNdBxkPOUoMQAEOAVODBIJ?=
 =?us-ascii?q?LAQEznGYBjQQNDQKFHYI9BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARI?=
 =?us-ascii?q?BbIJIglkEjUISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF?=
 =?us-ascii?q?9ozdXgQwNenEzGoImGoEgTxgNiBuOLUCBFhACT4kugjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2GbIwCpBxxemCMYgtlNGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBewIBGAEBgS6BTVIgEpNPgU0fg0OLY4EAgx4VhggTDIFbDQEBA?=
 =?us-ascii?q?QEBNQIBAYRATgEXgQ8kOgQNAgMNAQEFAQEBAQEFBAEBAhABAQEBAQYNCwYph?=
 =?us-ascii?q?UqCHQweAQQBAQEBAwMDAQEMAYNdBxkPOUoMQAEOAVODBIJLAQEznGYBjQQND?=
 =?us-ascii?q?QKFHYI9BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARIBbIJIglkEjUISI?=
 =?us-ascii?q?YEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF9ozdXgQwNenEzG?=
 =?us-ascii?q?oImGoEgTxgNiBuOLUCBFhACT4kugjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,427,1571695200"; 
   d="scan'208";a="323830586"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 13 Jan 2020 07:07:06 +0100
Received: (qmail 27176 invoked from network); 12 Jan 2020 03:06:27 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netdev@vger.kernel.org>; 12 Jan 2020 03:06:27 -0000
Date:   Sun, 12 Jan 2020 04:06:17 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     netdev@vger.kernel.org
Message-ID: <6890328.104949.1578798387135.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

